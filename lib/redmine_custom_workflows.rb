# encoding: utf-8
# frozen_string_literal: true
#
# Redmine plugin for Custom Workflows
#
# Copyright © 2015-19 Anton Argirov
# Copyright © 2019-22 Karel Pičman <karel.picman@kontron.com>
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

# Hooks
require File.dirname(__FILE__) + '/redmine_custom_workflows/hooks/views/base_view_hooks'

# Errors
require File.dirname(__FILE__) + '/redmine_custom_workflows/errors/workflow_error'

# Patches
require File.dirname(__FILE__) + '/redmine_custom_workflows/patches/attachment_patch'
require File.dirname(__FILE__) + '/redmine_custom_workflows/patches/group_patch'
require File.dirname(__FILE__) + '/redmine_custom_workflows/patches/issue_patch'
require File.dirname(__FILE__) + '/redmine_custom_workflows/patches/issue_relation_patch'
require File.dirname(__FILE__) + '/redmine_custom_workflows/patches/project_patch'
require File.dirname(__FILE__) + '/redmine_custom_workflows/patches/projects_helper_patch'
require File.dirname(__FILE__) + '/redmine_custom_workflows/patches/time_entry_patch'
require File.dirname(__FILE__) + '/redmine_custom_workflows/patches/user_patch'
require File.dirname(__FILE__) + '/redmine_custom_workflows/patches/version_patch'
require File.dirname(__FILE__) + '/redmine_custom_workflows/patches/wiki_content_patch'
require File.dirname(__FILE__) + '/redmine_custom_workflows/patches/wiki_page_patch'
