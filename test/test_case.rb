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

module RedmineCustomWorkflows
  module Test
    # Test case base class
    class TestCase < ActionDispatch::IntegrationTest
      fixtures :users, :email_addresses, :projects

      # Allow us to override the fixtures method to implement fixtures for our plugin.
      # Ultimately it allows for better integration without blowing redmine fixtures up,
      # and allowing us to suppliment redmine fixtures if we need to.
      def self.fixtures(*table_names)
        dir = File.join(File.dirname(__FILE__), 'fixtures')
        redmine_table_names = []
        table_names.each do |x|
          if File.exist?(File.join(dir, "#{x}.yml"))
            ActiveRecord::FixtureSet.create_fixtures(dir, x)
          else
            redmine_table_names << x
          end
        end
        super(redmine_table_names) if redmine_table_names.any?
      end

      def setup
        @jsmith = User.find_by(login: 'jsmith')
        @admin = User.find_by(login: 'admin')
        @project1 = Project.find 1
        User.current = nil
      end
    end
  end
end
