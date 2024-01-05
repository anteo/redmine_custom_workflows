# frozen_string_literal: true

# Redmine plugin for Custom Workflows
#
# Anton Argirov, Karel Pičman <karel.picman@kontron.com>
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

# Issue patch test class
class IssuePatchTest < RedmineCustomWorkflows::Test::UnitTest
  fixtures :issues

  def setup
    @issue1 = Issue.find 1
  end

  def test_truth
    assert_kind_of Issue, @issue1
  end

  def test_custom_workflow_messages
    @issue1.custom_workflow_messages[:notice] = 'Okay'
    assert_equal 'Okay', @issue1.custom_workflow_messages[:notice]
  end

  def test_custom_workflow_env
    @issue1.custom_workflow_env[:remote_ip] = '127.0.0.1'
    assert_equal '127.0.0.1', @issue1.custom_workflow_env[:remote_ip]
  end
end
