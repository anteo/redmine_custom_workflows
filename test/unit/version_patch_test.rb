# frozen_string_literal: true

# Redmine plugin for Custom Workflows
#
# Anton Argirov, Karel Pičman <karel.picman@kontron.com>
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

# Version patch test class
class VersionPatchTest < RedmineCustomWorkflows::Test::UnitTest
  fixtures :versions

  def setup
    @version1 = Version.find 1
  end

  def test_truth
    assert_kind_of Version, @version1
  end

  def test_custom_workflow_messages
    @version1.custom_workflow_messages[:notice] = 'Okay'
    assert_equal 'Okay', @version1.custom_workflow_messages[:notice]
  end

  def test_custom_workflow_env
    @version1.custom_workflow_env[:remote_ip] = '127.0.0.1'
    assert_equal '127.0.0.1', @version1.custom_workflow_env[:remote_ip]
  end
end
