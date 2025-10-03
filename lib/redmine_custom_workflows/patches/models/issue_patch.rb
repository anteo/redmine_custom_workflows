# frozen_string_literal: true

# Redmine plugin for Custom Workflows
#
# Anton Argirov, Karel Pičman <karel.picman@kontron.com>
#
# This file is part of Redmine OAuth plugin.
#
# Redmine Custom Workflows plugin is free software: you can redistribute it and/or modify it under the terms of the GNU
# General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your
#  option) any later version.
#
# Redmine Custom Workflows plugin is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
# even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public License along with Redmine Custom Workflows plugin. If not,
# see <https://www.gnu.org/licenses/>.

module RedmineCustomWorkflows
  module Patches
    module Models
      # Issue model patch
      module IssuePatch
        def custom_workflow_messages
          @custom_workflow_messages ||= {}
        end

        def custom_workflow_env
          @custom_workflow_env ||= {}
        end

        def self.prepended(base)
          base.class_eval do
            before_save :before_save_custom_workflows
            after_save :after_save_custom_workflows
            before_destroy :before_destroy_custom_workflows
            after_destroy :after_destroy_custom_workflows
            validate :validate_status

            acts_as_attachable before_add: proc {}, # => before_add_for_attachments
                               after_add: :attachment_added, # inherited
                               before_remove: proc {}, # => before_remove_for_attachments
                               after_remove: :attachment_removed # inherited

            def self.attachments_callback(event, issue, attachment)
              issue.instance_variable_set :@issue, issue
              issue.instance_variable_set :@attachment, attachment
              CustomWorkflow.run_shared_code?(issue) if event.to_s.starts_with? 'before_'
              CustomWorkflow.run_custom_workflows? :issue_attachments, issue, event
            end

            %i[before_add before_remove after_add after_remove].each do |observable|
              send(:"#{observable}_for_attachments") << lambda { |event, issue, attachment|
                Issue.attachments_callback event, issue, attachment
              }
            end
          end
        end

        def validate_status
          unless @saved_attributes && (@saved_attributes['status_id'] != status_id) && new_statuses_allowed_to(
            User.current, new_record?
          ).collect(&:id).exclude?(status_id)
            return true
          end

          status_was = IssueStatus.find_by(id: status_id_was)
          status_new = IssueStatus.find_by(id: status_id)
          errors.add :status,
                     :new_status_invalid,
                     old_status: status_was&.name,
                     new_status: status_new&.name
        end

        def before_save_custom_workflows
          @issue = self
          @saved_attributes = attributes.dup
          CustomWorkflow.run_shared_code? self
          CustomWorkflow.run_custom_workflows? :issue, self, :before_save
          throw :abort if errors.any?

          errors.empty? && (@saved_attributes == attributes || valid?)
        ensure
          @saved_attributes = nil
        end

        def after_save_custom_workflows
          CustomWorkflow.run_custom_workflows? :issue, self, :after_save
        end

        def before_destroy_custom_workflows
          res = CustomWorkflow.run_custom_workflows?(:issue, self, :before_destroy)
          throw :abort if res == false
        end

        def after_destroy_custom_workflows
          CustomWorkflow.run_custom_workflows? :issue, self, :after_destroy
        end
      end
    end
  end
end

# Apply the patch
Issue.prepend RedmineCustomWorkflows::Patches::Models::IssuePatch
