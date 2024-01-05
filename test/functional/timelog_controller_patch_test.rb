# frozen_string_literal: true

# Redmine plugin for Document Management System "Features"
#
# Karel Pičman <karel.picman@kontron.com>
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

require File.expand_path('../../test_helper', __FILE__)

# Time controller patch test
class TimelogControllerPatchTest < RedmineCustomWorkflows::Test::TestCase
  fixtures :user_preferences, :issues, :versions, :trackers, :projects_trackers, :issue_statuses,
           :enabled_modules, :enumerations, :issue_categories, :custom_workflows, :custom_workflows_projects,
           :time_entries, :roles, :members, :member_roles

  def setup
    super
    @te1 = TimeEntry.find 1
    post '/login', params: { username: 'jsmith', password: 'jsmith' }
    @controller = TimelogController.new
  end

  def test_delete_with_cw
    delete "/time_entries/#{@te1.id}"
    assert_response :redirect
    assert_equal 'Custom workflow', @controller.flash[:notice]
  end

  def test_cw_env
    delete "/time_entries/#{@te1.id}"
    assert_response :redirect
    assert_equal request.remote_ip, @controller.flash[:warning]
  end
end
