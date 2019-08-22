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

require_dependency File.dirname(__FILE__) + '/lib/redmine_custom_workflows.rb'

ActiveSupport::Dependencies.autoload_paths << File.join(File.dirname(__FILE__), 'app')

def custom_workflows_init
  # Administration menu extension
  Redmine::MenuManager.map :admin_menu do |menu|
    menu.push :custom_workflows, { controller: 'custom_workflows', action: 'index'},
         caption: :label_custom_workflow_plural, html: { class: 'icon icon-workflows workflows'}
  end
end

if Redmine::Plugin.installed?(:easy_extensions)
  ActiveSupport.on_load(:easyproject, yield: true) do
    custom_workflows_init
  end
else
  custom_workflows_init
end
