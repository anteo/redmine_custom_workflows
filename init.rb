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

require 'redmine'

Redmine::Plugin.register :redmine_custom_workflows do
  name 'Redmine Custom Workflow plugin'
  author 'Anton Argirov'
  description 'Allows to create custom workflows for issues, defined in the plain Ruby language'
  version '1.0.0 devel'
  url 'http://www.redmine.org/plugins/custom-workflows'

  # In order to the plugin in Redmine < 4 (Rails < 5), comment out the following line and modify Gemfile according to
  # the recommendation written there.
  requires_redmine version_or_higher: '4.0.0'

  permission :manage_project_workflow, {}, :require => :member
end

require_dependency File.dirname(__FILE__) + '/lib/redmine_custom_workflows.rb'

# Administration menu extension
Redmine::MenuManager.map :admin_menu do |menu|
  menu.push :custom_workflows, { controller: 'custom_workflows', action: 'index'},
       caption: :label_custom_workflow_plural, html: { class: 'icon icon-workflows'}
end
