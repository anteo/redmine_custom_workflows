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
  module Patches
    module Controllers
      # Issue relations controller patch
      module IssueRelationsControllerPatch
        ################################################################################################################
        # New methods
        #

        def self.prepended(base)
          base.class_eval do
            before_action :set_env
            after_action :display_custom_workflow_messages
          end
        end

        def set_env
          objects = model_objects
          return unless objects&.any?

          objects.each do |o|
            o.custom_workflow_env[:remote_ip] = request.remote_ip
          end
        end

        def display_custom_workflow_messages
          objects = model_objects
          return unless objects&.any?

          objects.each do |o|
            next if o&.custom_workflow_messages&.empty?

            o.custom_workflow_messages.each do |key, value|
              if value.present?
                flash[key] = value
              else
                flash.delete key
              end
            end
            o.custom_workflow_messages.clear
          end
        end

        private

        def model_objects
          if @relations
            @relations
          elsif @relation
            [@relation]
          end
        end
      end
    end
  end
end

IssueRelationsController.prepend RedmineCustomWorkflows::Patches::Controllers::IssueRelationsControllerPatch
