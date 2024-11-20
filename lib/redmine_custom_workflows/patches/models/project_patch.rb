# frozen_string_literal: true

# Redmine plugin for Custom Workflows
#
# Anton Argirov, Karel Pičman <karel.picman@kontron.com>
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

module RedmineCustomWorkflows
  module Patches
    module Models
      # Project model patch
      module ProjectPatch
        def custom_workflow_messages
          @custom_workflow_messages ||= {}
        end

        def custom_workflow_env
          @custom_workflow_env ||= {}
        end

        def self.prepended(base)
          base.class_eval do
            has_and_belongs_to_many :custom_workflows

            safe_attributes :custom_workflow_ids,
                            if: lambda { |project, user|
                              project.new_record? || user.allowed_to?(:manage_project_workflow, project)
                            }

            before_save :before_save_custom_workflows
            after_save :after_save_custom_workflows
            before_destroy :before_destroy_custom_workflows
            after_destroy :after_destroy_custom_workflows

            acts_as_attachable view_permission: :view_files, # inherited
                               edit_permission: :manage_files, # inherited
                               delete_permission: :manage_files, # inherited
                               before_add: proc {}, # => before_add_for_attachments
                               after_add: proc {}, # => after_add_for_attachments
                               before_remove: proc {}, # => before_remove_for_attachments
                               after_remove: proc {} # => after_remove_for_attachments

            def self.attachments_callback(event, project, attachment)
              project.instance_variable_set(:@project, project)
              project.instance_variable_set(:@attachment, attachment)
              CustomWorkflow.run_shared_code(project) if event.to_s.starts_with? 'before_'
              CustomWorkflow.run_custom_workflows(:project_attachments, project, event)
            end

            %i[before_add before_remove after_add after_remove].each do |observable|
              send(:"#{observable}_for_attachments") << lambda { |event, project, attachment|
                Project.attachments_callback event, project, attachment
              }
            end
          end
        end

        def before_save_custom_workflows
          @project = self
          @saved_attributes = attributes.dup
          CustomWorkflow.run_shared_code self
          CustomWorkflow.run_custom_workflows :project, self, :before_save
          throw :abort if errors.any?

          errors.empty? && (@saved_attributes == attributes || valid?)
        ensure
          @saved_attributes = nil
        end

        def after_save_custom_workflows
          CustomWorkflow.run_custom_workflows :project, self, :after_save
        end

        def before_destroy_custom_workflows
          res = CustomWorkflow.run_custom_workflows :project, self, :before_destroy
          throw :abort if res == false
        end

        def after_destroy_custom_workflows
          CustomWorkflow.run_custom_workflows :project, self, :after_destroy
        end
      end
    end
  end
end

# Apply the patch
if Redmine::Plugin.installed?('easy_extensions')
  RedmineExtensions::PatchManager.register_model_patch 'Project',
                                                       'RedmineCustomWorkflows::Patches::Models::ProjectPatch'
else
  Project.prepend RedmineCustomWorkflows::Patches::Models::ProjectPatch
end
