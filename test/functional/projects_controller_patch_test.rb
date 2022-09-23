# encoding: utf-8
# frozen_string_literal: true
#
# Redmine plugin for Document Management System "Features"
#
# Copyright © 2011-22 Karel Pičman <karel.picman@kontron.com>
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

class ProjectsControllerPatchTest < RedmineCustomWorkflows::Test::TestCase

  fixtures :user_preferences, :issues, :versions, :trackers, :projects_trackers, :enabled_modules,
           :enumerations, :custom_workflows, :custom_workflows_projects, :roles, :members, :member_roles

  def setup
    super
    @request.session[:user_id] = @jsmith.id
    @controller = ProjectsController.new
  end

  def test_update_with_cw
    post :update, params: { id: @project1.id, project: { name: 'Updated name' } }
    assert_redirected_to settings_project_path(@project1)
    assert_equal 'Custom workflow', @controller.flash[:notice]
  end

end