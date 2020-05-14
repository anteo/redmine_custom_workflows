# encoding: utf-8
# frozen_string_literal: true
#
# Redmine plugin for Custom Workflows
#
# Copyright © 2015-19 Anton Argirov
# Copyright © 2019-20 Karel Pičman <karel.picman@kontron.com>
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

Redmine::Plugin.register :redmine_custom_workflows do
  if Redmine::Plugin.installed?(:easy_extensions)
    name 'Easy Custom Workflow plugin'
    url 'https://www.easyredmine.com'
    author_url 'https://www.easyredmine.com'
  else
    name 'Redmine Custom Workflow plugin'
    url 'https://www.redmine.org/plugins/redmine_custom_workflows'
    author_url 'https://github.com/anteo/redmine_custom_workflows/graphs/contributors'
  end
  author 'Anton Argirov/Karel Pičman'
  description 'Allows to create custom workflows for objects, defined in the plain Ruby language'
  version '1.0.3 devel'

  requires_redmine version_or_higher: '4.1.0'

  permission :manage_project_workflow, {}, require: :member
end

unless Redmine::Plugin.installed?(:easy_extensions)
  require_relative 'after_init'
end
