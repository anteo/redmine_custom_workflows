# frozen_string_literal: true
#
# Redmine plugin for Document Management System "Features"
#
# Copyright © 2019-23 Karel Pičman <karel.picman@kontron.com>
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

# Issue controller patch test
class IssuesControllerPatchTest < RedmineCustomWorkflows::Test::TestCase
  fixtures :user_preferences, :issues, :versions, :trackers, :projects_trackers, :issue_statuses,
           :enabled_modules, :enumerations, :issue_categories, :custom_workflows, :custom_workflows_projects, :roles,
           :members, :member_roles

  def setup
    super
    @issue1 = Issue.find 1
    @request.session[:user_id] = @jsmith.id
    @controller = IssuesController.new
  end

  def test_update_with_cw
    put :update, params: { id: @issue1.id, issue: { subject: 'Updated subject' } }
    assert_redirected_to action: 'show', id: @issue1.id
    assert_equal 'Custom workflow', @controller.flash[:notice]
  end

  def test_delete_with_cw
    delete :destroy, params: { id: @issue1.id, todo: 'destroy' }
    assert_response :redirect
    assert_equal 'Issue cannot be deleted', @controller.flash[:error]
    assert Issue.find_by(id: @issue1.id)
  end

  def test_cw_env
    put :update, params: { id: @issue1.id, issue: { subject: 'Updated subject' } }
    assert_redirected_to action: 'show', id: @issue1.id
    assert_equal request.remote_ip, @controller.flash[:warning]
  end
end
