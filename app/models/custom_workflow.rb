# encoding: utf-8
#
# Redmine plugin for Custom Workflows
#
# Copyright Anton Argirov
# Copyright Karel Pičman <karel.picman@kontron.com>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

class CustomWorkflow < ActiveRecord::Base
  OBSERVABLES = [:issue, :issue_attachments, :user, :attachment, :group, :group_users, :project, :project_attachments,
                 :wiki_content, :wiki_page_attachments, :time_entry, :version, :shared]
  PROJECT_OBSERVABLES = [:issue, :issue_attachments, :project, :project_attachments, :wiki_content, :wiki_page_attachments, :time_entry, :version]
  COLLECTION_OBSERVABLES = [:group_users, :issue_attachments, :project_attachments, :wiki_page_attachments]
  SINGLE_OBSERVABLES = [:issue, :user, :group, :attachment, :project, :wiki_content, :time_entry, :version]

  has_and_belongs_to_many :projects
  acts_as_list

  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false
  validates_format_of :author, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, :allow_blank => true
  validate :validate_syntax, :validate_scripts_presence, :if => Proc.new {|workflow| workflow.respond_to?(:observable) and workflow.active?}

  scope :active, lambda { where(:active => true) }
  scope :for_project, (lambda do |project|
    where("is_for_all=? OR EXISTS (SELECT * FROM #{reflect_on_association(:projects).join_table} WHERE project_id=? AND custom_workflow_id=id)",
          true, project.id)
  end)

  def self.import_from_xml(xml)
    attributes = Hash.from_xml(xml).values.first
    attributes.delete('exported_at')
    attributes.delete('plugin_version')
    attributes.delete('ruby_version')
    attributes.delete('rails_version')
    CustomWorkflow.new(attributes)
  end

  def self.log_message(str, object)
    Rails.logger.info str + " for #{object.class} (\##{object.id}) \"#{object}\""
  end

  def self.run_shared_code(object)
    log_message '= Running shared code', object
    if CustomWorkflow.table_exists? # Due to DB migration
      CustomWorkflow.active.where(observable: :shared).find_each do |workflow|
        unless workflow.run(object, :shared_code)
          log_message '= Abort running shared code', object
          return false
        end
      end
    end
    log_message '= Finished running shared code', object
    true
  end

  def self.run_custom_workflows(observable, object, event)
    if CustomWorkflow.table_exists? # Due to DB migration
      workflows = CustomWorkflow.active.where(observable: observable)
      if PROJECT_OBSERVABLES.include? observable
        return true unless object.project
        workflows = workflows.for_project(object.project)
      end
      return true unless workflows.any?
      log_message "= Running #{event} custom workflows", object
      workflows.each do |workflow|
        unless workflow.run(object, event)
          log_message "= Abort running #{event} custom workflows", object
          return false
        end
      end
      log_message "= Finished running #{event} custom workflows", object
    end
    true
  end

  def run(object, event)
    return true unless attribute_present?(event)
    Rails.logger.info "== Running #{event} custom workflow \"#{name}\""
    object.instance_eval(read_attribute(event))
    true
  rescue WorkflowError => e
    Rails.logger.info "== User workflow error: #{e.message}"
    object.errors.add :base, e.error
    false
  rescue Exception => e
    Rails.logger.error "== Custom workflow exception: #{e.message}\n #{e.backtrace.join("\n ")}"
    object.errors.add :base, :custom_workflow_error
    false
  end

  def has_projects_association?
    PROJECT_OBSERVABLES.include? observable.to_sym
  end

  def validate_syntax_for(object, event)
    object.instance_eval(read_attribute(event)) if respond_to?(event) && read_attribute(event)
  rescue WorkflowError => _
  rescue Exception => e
    errors.add event, :invalid_script, error: e
  end

  def validate_scripts_presence
    case observable.to_sym
      when :shared
        fields = [shared_code]
      when *SINGLE_OBSERVABLES
        fields = [before_save, after_save, before_destroy, after_destroy]
      when *COLLECTION_OBSERVABLES
        fields = [before_add, after_add, before_remove, after_remove]
      else
        fields = []
    end
    unless fields.any? {|field| field.present?}
      errors.add :base, :scripts_absent
    end
  end

  def validate_syntax
    case observable.to_sym
      when :shared
        CustomWorkflow.run_shared_code self
        validate_syntax_for self, :shared_code
      when *SINGLE_OBSERVABLES
        object = observable.camelize.constantize.new
        object.send :instance_variable_set, "@#{observable}", object # compatibility with 0.0.1
        CustomWorkflow.run_shared_code object
        [:before_save, :after_save, :before_destroy, :after_destroy].each {|field| validate_syntax_for object, field}
      when *COLLECTION_OBSERVABLES
        object = nil
        case observable.to_sym
          when :group_users
            object = Group.new
            object.send :instance_variable_set, :@user, User.new
            object.send :instance_variable_set, :@group, object
          when :issue_attachments
            object = Issue.new
            object.send :instance_variable_set, :@attachment, Attachment.new
            object.send :instance_variable_set, :@issue, object
          when :project_attachments
            object = Project.new
            object.send :instance_variable_set, :@attachment, Attachment.new
            object.send :instance_variable_set, :@project, object
          when :wiki_page_attachments
            object = WikiPage.new
            object.send :instance_variable_set, :@attachment, Attachment.new
            object.send :instance_variable_set, :@page, object
        end
        CustomWorkflow.run_shared_code object
        [:before_add, :after_add, :before_remove, :after_remove].each {|field| validate_syntax_for object, field}
    end
  end

  def export_as_xml
    only = [:author, :name, :description, :before_save, :after_save, :shared_code, :observable,
            :before_add, :after_add, :before_remove, :after_remove, :before_destroy, :after_destroy, :created_at]
    only = only.select { |p| self[p] }
    to_xml :only => only  do |xml|
      xml.tag! 'exported-at', Time.current.xmlschema
      xml.tag! 'plugin-version', Redmine::Plugin.find(:redmine_custom_workflows).version
      xml.tag! 'ruby-version', "#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}"
      xml.tag! 'rails-version', Rails::VERSION::STRING
    end
  end

  def <=>(other)
    self.position <=> other.position
  end

  def to_s
    name
  end
end
