class WorkflowError < StandardError
  attr_accessor :error

  def initialize(message)
    @error = message.dup
    super message
  end
end

class CustomWorkflow < ActiveRecord::Base
  OBSERVABLES = [:issue, :user, :group, :group_users, :shared]
  PROJECT_OBSERVABLES = [:issue]
  COLLECTION_OBSERVABLES = [:group_users]

  attr_protected :id
  has_and_belongs_to_many :projects
  acts_as_list

  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false
  validates_format_of :author, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, :allow_blank => true
  validate :validate_syntax

  default_scope { order(:position => :asc) }
  scope :active, lambda { where(:active => true) }
  scope :for_project, (lambda do |project|
    where("is_for_all OR EXISTS (SELECT * FROM #{reflect_on_association(:projects).join_table} WHERE project_id=? AND custom_workflow_id=id)", project.id)
  end)
  scope :observing, lambda { |observable| where(:observable => observable) }

  class << self
    def import_from_xml(xml)
      attributes = Hash.from_xml(xml).values.first
      attributes.delete('exported_at')
      attributes.delete('plugin_version')
      attributes.delete('ruby_version')
      attributes.delete('rails_version')
      CustomWorkflow.new(attributes)
    end

    def run_shared_code(object)
      workflows = CustomWorkflow.observing(:shared).active
      Rails.logger.info "= Running shared code for #{object.class} \"#{object}\" (\##{object.id})"
      workflows.each do |workflow|
        return false unless workflow.run(object, :shared_code)
      end
      Rails.logger.info "= Finished running shared code for #{object.class} \"#{object}\" (\##{object.id})"
      true
    end

    def run_custom_workflows(observable, object, event)
      workflows = CustomWorkflow.active.observing(observable)
      if object.respond_to? :project
        return true unless object.project
        workflows = workflows.for_project(object.project)
      end
      return true unless workflows.any?
      Rails.logger.info "= Running #{event} custom workflows for #{object.class} \"#{object}\" (\##{object.id})"
      workflows.each do |workflow|
        return false unless workflow.run(object, event)
      end
      Rails.logger.info "= Finished running #{event} custom workflows for #{object.class} \"#{object}\" (\##{object.id})"
      true
    end
  end

  def run(object, event)
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
  rescue WorkflowError => e
  rescue Exception => e
    errors.add event, :invalid_script, :error => e
  end

  def validate_syntax
    case observable
      when 'shared'
        CustomWorkflow.run_shared_code(self)
        validate_syntax_for(self, :shared_code)
      when 'user', 'group', 'issue'
        object = observable.camelize.constantize.new
        object.send :instance_variable_set, "@#{observable}", object # compatibility with 0.0.1
        CustomWorkflow.run_shared_code(object)
        validate_syntax_for(object, :before_save)
        validate_syntax_for(object, :after_save)
      when 'group_users'
        @user = User.new
        @group = Group.new
        CustomWorkflow.run_shared_code(self)
        validate_syntax_for(self, :before_add)
        validate_syntax_for(self, :before_remove)
        validate_syntax_for(self, :after_add)
        validate_syntax_for(self, :after_remove)
    end
  end

  def export_as_xml
    only = [:author, :name, :description, :before_save, :after_save, :shared_code, :observable,
            :before_add, :after_add, :before_remove, :after_remove, :created_at]
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
