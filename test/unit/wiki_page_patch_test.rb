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

# Wiki page test class
class WikiPagePatchTest < RedmineCustomWorkflows::Test::UnitTest
  fixtures :wiki_pages

  def setup
    @wiki_page1 = WikiPage.find 1
  end

  def test_truth
    assert_kind_of WikiPage, @wiki_page1
  end

  def test_custom_workflow_messages
    @wiki_page1.custom_workflow_messages[:notice] = 'Okay'
    assert_equal 'Okay', @wiki_page1.custom_workflow_messages[:notice]
  end

  def test_custom_workflow_env
    @wiki_page1.custom_workflow_env[:remote_ip] = '127.0.0.1'
    assert_equal '127.0.0.1', @wiki_page1.custom_workflow_env[:remote_ip]
  end
end
