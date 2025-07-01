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
      # Wiki page model patch
      module WikiPagePatch
        def custom_workflow_messages
          @custom_workflow_messages ||= {}
        end

        def custom_workflow_env
          @custom_workflow_env ||= {}
        end

        def self.prepended(base)
          base.class_eval do
            acts_as_attachable delete_permission: :delete_wiki_pages_attachments, # inherited
                               before_add: proc {}, # => before_add_for_attachments
                               after_add: proc {}, # => after_add_for_attachments
                               before_remove: proc {}, # => before_remove_for_attachments
                               after_remove: proc {} # => after_remove_for_attachments

            def self.attachments_callback(event, page, attachment)
              page.instance_variable_set :@page, page
              page.instance_variable_set :@attachment, attachment
              CustomWorkflow.run_shared_code(page) if event.to_s.starts_with? 'before_'
              CustomWorkflow.run_custom_workflows :wiki_page_attachments, page, event
            end

            %i[before_add before_remove after_add after_remove].each do |observable|
              send(:"#{observable}_for_attachments") << lambda { |event, page, attachment|
                WikiPage.attachments_callback(event, page, attachment)
              }
            end
          end
        end
      end
    end
  end
end

# Apply the patch
WikiPage.prepend RedmineCustomWorkflows::Patches::Models::WikiPagePatch
