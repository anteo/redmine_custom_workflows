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

module RedmineCustomWorkflows
  module Test
    # Unit test base class
    class UnitTest < ActiveSupport::TestCase
      # Allow us to override the fixtures method to implement fixtures for our plugin.
      # Ultimately it allows for better integration without blowing redmine fixtures up,
      # and allowing us to suppliment redmine fixtures if we need to.
      def self.fixtures(*table_names)
        dir = File.join(File.dirname(__FILE__), '/fixtures')
        table_names.each do |x|
          ActiveRecord::FixtureSet.create_fixtures(dir, x) if File.exist?("#{dir}/#{x}.yml")
        end
        super(table_names)
      end

      protected

      def last_email
        ActionMailer::Base.deliveries.last
      end

      def text_part(email)
        email.parts.detect { |part| part.content_type.include?('text/plain') }
      end

      def html_part(email)
        email.parts.detect { |part| part.content_type.include?('text/html') }
      end
    end
  end
end
