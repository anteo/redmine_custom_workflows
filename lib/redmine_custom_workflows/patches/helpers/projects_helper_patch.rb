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
    module Helpers
      # Project helper patch
      module ProjectsHelperPatch
        def project_settings_tabs
          tabs = super
          if User.current.allowed_to?(:manage_project_workflow, @project)
            tabs << {
              name: 'custom_workflows',
              action: :manage_project_workflow,
              partial: 'projects/settings/custom_workflow',
              label: :label_custom_workflow_plural
            }
          end
          tabs
        end
      end
    end
  end
end

# Apply the patch
ProjectsController.send :helper, RedmineCustomWorkflows::Patches::Helpers::ProjectsHelperPatch
