# frozen_string_literal: true

# Redmine plugin for Document Management System "Features"
#
# Karel Pičman <karel.picman@kontron.com>
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

require File.expand_path('../../test_helper', __FILE__)

# Version controller patch test
class VersionsControllerPatchTest < RedmineCustomWorkflows::Test::TestCase

  def setup
    super
    @version1 = Version.find 1
    post '/login', params: { username: 'jsmith', password: 'jsmith' }
    @controller = VersionsController.new
  end

  def test_update_with_cw
    put "/versions/#{@version1.id}", params: { version: { name: 'Updated version' } }
    assert_redirected_to settings_project_path(id: @project1, tab: 'versions')
    assert_equal 'Custom workflow', @controller.flash[:notice]
  end

  def test_cw_env
    put "/versions/#{@version1.id}", params: { version: { name: 'Updated version' } }
    assert_redirected_to settings_project_path(id: @project1, tab: 'versions')
    assert_equal request.remote_ip, @controller.flash[:warning]
  end
end
