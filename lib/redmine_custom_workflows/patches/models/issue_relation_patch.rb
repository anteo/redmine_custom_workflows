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
      # Issue relation model patch
      module IssueRelationPatch
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
          end

          base.prepend InstanceMethods
        end

        # Instance methods module
        module InstanceMethods
          ##############################################################################################################
          # Overridden methods

          # Override IssueRelation.to_s to rescue NoMethodError during CustomWorkflow.validate_syntax due to
          # logging of temporarily instatiated IssueRelation with no related issues set.
          def to_s(issue = nil)
            super
          rescue NoMethodError => e
            raise e if issue_from.present? || issue_to.present?
          end

          ##############################################################################################################
          # New methods
          #
          def before_save_custom_workflows
            @issue_relation = self
            @saved_attributes = attributes.dup
            CustomWorkflow.run_shared_code self
            CustomWorkflow.run_custom_workflows :issue_relation, self, :before_save
            throw :abort if errors.any?
            errors.empty? && (@saved_attributes == attributes || valid?)
          ensure
            @saved_attributes = nil
          end

          def after_save_custom_workflows
            CustomWorkflow.run_custom_workflows :issue_relation, self, :after_save
          end

          def before_destroy_custom_workflows
            res = CustomWorkflow.run_custom_workflows :issue_relation, self, :before_destroy
            throw :abort if res == false
          end

          def after_destroy_custom_workflows
            CustomWorkflow.run_custom_workflows :issue_relation, self, :after_destroy
          end
        end
      end
    end
  end
end

# Apply the patch
if Redmine::Plugin.installed?('easy_extensions')
  RedmineExtensions::PatchManager.register_model_patch 'IssueRelation',
                                                       'RedmineCustomWorkflows::Patches::Models::IssueRelationPatch'
else
  IssueRelation.prepend RedmineCustomWorkflows::Patches::Models::IssueRelationPatch
end
