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

module RedmineCustomWorkflows
  module Patches
    module ProjectsHelperPatch

      def project_settings_tabs
        tabs = super
        tabs << { name: 'custom_workflows', action: :manage_project_workflow, partial: 'projects/settings/custom_workflow',
                 label: :label_custom_workflow_plural } if User.current.allowed_to?(:manage_project_workflow, @project)
        tabs
      end

    end
  end
end

if Redmine::Plugin.installed?(:easy_extensions)
  RedmineExtensions::PatchManager.register_helper_patch 'ProjectsHelper',
    'RedmineCustomWorkflows::Patches::ProjectsHelperPatch', prepend: true
else
  ProjectsController.send :helper, RedmineCustomWorkflows::Patches::ProjectsHelperPatch
end