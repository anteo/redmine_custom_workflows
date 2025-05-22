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

# Attachment controller patch test
class AttachmentsControllerPatchTest < RedmineCustomWorkflows::Test::TestCase
  fixtures :attachments, :enabled_modules, :custom_workflows, :custom_workflows_projects,
           :roles, :members, :member_roles

  def setup
    super
    @attachment8 = Attachment.find 8
    post '/login', params: { username: 'jsmith', password: 'jsmith' }
    @controller = AttachmentsController.new
  end

  def test_delete_with_cw
    delete "/attachments/#{@attachment8.id}"
    assert_response :redirect
    assert_equal 'Custom workflow', @controller.flash[:notice]
  end

  def test_cw_env
    delete "/attachments/#{@attachment8.id}"
    assert_response :redirect
    assert_equal request.remote_ip, @controller.flash[:warning]
  end
end
