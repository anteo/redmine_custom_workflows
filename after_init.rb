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

require 'redmine'
require "#{File.dirname(__FILE__)}/lib/redmine_custom_workflows"

def custom_workflows_init
  # Administration menu extension
  Redmine::MenuManager.map :admin_menu do |menu|
    menu.push :custom_workflows, { controller: 'custom_workflows', action: 'index' },
              caption: :label_custom_workflow_plural, icon: 'workflows',
              html: { class: 'icon icon-workflows workflows' }
  end
end

if Redmine::Plugin.installed?('easy_extensions')
  ActiveSupport.on_load(:easyproject, yield: true) do
    custom_workflows_init
  end
else
  custom_workflows_init
end
