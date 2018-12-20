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

require File.expand_path('../../test_helper', __FILE__)

class CustomWorkflowsControllerTest < RedmineCustomWorkflows::Test::TestCase

  fixtures :users, :email_addresses, :custom_workflows, :custom_workflows_projects, :projects, :roles,
           :members, :member_roles

  def setup
    @cw1 = CustomWorkflow.find 1
    @project1 = Project.find 1
    @admin = User.find 1
    @manager = User.find 2
    User.current = nil
    @request.session[:user_id] = @admin.id
  end

  def test_truth
    assert_kind_of CustomWorkflow, @cw1
    assert_kind_of Project, @project1
    assert_kind_of User, @manager
    assert_kind_of User, @admin
  end

  def test_index_admin
    get :index
    assert_response :success
  end

  def test_index_non_admin
    @request.session[:user_id] = @manager.id
    get :index
    assert_response :forbidden
  end

end