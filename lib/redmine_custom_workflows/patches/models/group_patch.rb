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
      # Group model patch
      module GroupPatch
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

            has_and_belongs_to_many :users, # inherited
                                    join_table: "#{table_name_prefix}groups_users#{table_name_suffix}", # inherited
                                    before_add: proc {}, # => before_add_for_users
                                    after_add: :user_added, # inherited
                                    before_remove: proc {}, # => before_remove_for_users
                                    after_remove: :user_removed # inherited

            def self.users_callback(event, group, user)
              group.instance_variable_set :@group, group
              group.instance_variable_set :@user, user
              CustomWorkflow.run_shared_code(group) if event.to_s.starts_with? 'before_'
              CustomWorkflow.run_custom_workflows :group_users, group, event
            end

            %i[before_add before_remove after_add after_remove].each do |observable|
              send(:"#{observable}_for_users") << lambda { |event, group, user|
                Group.users_callback(event, group, user)
              }
            end
          end
        end

        def before_save_custom_workflows
          @group = self
          @saved_attributes = attributes.dup
          CustomWorkflow.run_shared_code self
          CustomWorkflow.run_custom_workflows :group, self, :before_save
          throw :abort if errors.any?

          errors.empty? && (@saved_attributes == attributes || valid?)
        ensure
          @saved_attributes = nil
        end

        def after_save_custom_workflows
          CustomWorkflow.run_custom_workflows :group, self, :after_save
        end

        def before_destroy_custom_workflows
          res = CustomWorkflow.run_custom_workflows :group, self, :before_destroy
          throw :abort if res == false
        end

        def after_destroy_custom_workflows
          CustomWorkflow.run_custom_workflows :group, self, :after_destroy
        end
      end
    end
  end
end

# Apply the patch
if Redmine::Plugin.installed?('easy_extensions')
  RedmineExtensions::PatchManager.register_model_patch 'Group', 'RedmineCustomWorkflows::Patches::Models::GroupPatch'
else
  Group.prepend RedmineCustomWorkflows::Patches::Models::GroupPatch
end
