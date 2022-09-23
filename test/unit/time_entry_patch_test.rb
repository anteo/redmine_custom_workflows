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

require File.expand_path('../../test_helper', __FILE__)

class TimeEntryPatchTest < RedmineCustomWorkflows::Test::UnitTest
  fixtures :time_entries

  def setup
    @time_entry1 = TimeEntry.find 1
  end

  def test_truth
    assert_kind_of TimeEntry, @time_entry1
  end

  def test_custom_workflow_messages
    @time_entry1.custom_workflow_messages[:notice] = 'Okay'
    assert_equal 'Okay', @time_entry1.custom_workflow_messages[:notice]
  end

end