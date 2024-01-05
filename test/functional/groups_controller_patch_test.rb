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

# Group controller patch test
class GroupControllerPatchTest < RedmineCustomWorkflows::Test::TestCase
  include Rails.application.routes.url_helpers
  fixtures :custom_workflows, :custom_workflows_projects

  def setup
    super
    @group10 = Group.find 10
    post '/login', params: { username: 'admin', password: 'admin' }
    @controller = GroupsController.new
    default_url_options[:host] = 'www.example.com'
  end

  def test_update_with_cw
    @request.headers['Referer'] = edit_group_path(id: @group10.id)
    put "/groups/#{@group10.id}", params: { group: { name: 'Updated name' } }
    assert_redirected_to groups_path
    assert_equal 'Custom workflow', @controller.flash[:notice]
  end

  def test_cw_env
    @request.headers['Referer'] = edit_group_path(id: @group10.id)
    put "/groups/#{@group10.id}/", params: { group: { name: 'Updated name' } }
    assert_redirected_to groups_path
    assert_equal request.remote_ip, @controller.flash[:warning]
  end
end
