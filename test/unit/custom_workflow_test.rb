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

# Custom workflow test class
class CustomWorkflowTest < RedmineCustomWorkflows::Test::UnitTest
  def setup
    @cw1 = CustomWorkflow.find 1
  end

  def test_truth
    assert_kind_of CustomWorkflow, @cw1
  end

  def test_to_s
    assert_equal @cw1.name, @cw1.to_s
  end

  def test_import_from_xml
    xml = %(
    <hash>
      <id type="integer">20</id>
      <before-save>Rails.logger.info '&gt;&gt;&gt; Okay'</before-save>
      <after-save></after-save>
      <name>cw 1</name>
      <description>Desc.</description>
      <position type="integer">4</position>
      <is-for-all type="boolean">false</is-for-all>
      <author>karel.picman@kontron.com</author>
      <created-at type="dateTime">2022-09-21T12:14:21Z</created-at>
      <updated-at type="dateTime">2022-09-21T12:14:21Z</updated-at>
      <active type="boolean">true</active>
      <observable>issue</observable>
      <shared-code nil="true"/>
      <before-add nil="true"/>
      <after-add nil="true"/>
      <before-remove nil="true"/>
      <after-remove nil="true"/>
      <before-destroy></before-destroy>
      <after-destroy></after-destroy>
      <exported-at>2022-09-21T12:31:17Z</exported-at>
      <plugin-version>2.0.6 devel</plugin-version>
      <ruby-version>3.0.2-p107</ruby-version>
      <rails-version>6.1.6.1</rails-version>
    </hash>
    )
    cw = CustomWorkflow.import_from_xml(xml)
    assert cw
  end

  def test_export_as_xml
    xml = @cw1.export_as_xml
    assert xml.include?("<name>#{@cw1}</name>")
  end
end
