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

module RedmineCustomWorkflows
  module Patches
    module Controllers
      module VersionsControllerPatch

        ################################################################################################################
        # New methods
        #

        def self.prepended(base)
          base.class_eval do
            after_action :display_custom_workflow_messages
          end
        end

        def display_custom_workflow_messages
          if @versions
            objects = @versions
          elsif @version
            objects = [@version]
          end
          if objects&.any?
            objects.each do |o|
              if o&.custom_workflow_messages&.any?
                o.custom_workflow_messages.each do |key, value|
                  if value.empty?
                    flash.delete key
                  else
                    flash[key] = value
                  end
                end
                o.custom_workflow_messages = {}
              end
            end
          end
        end

      end
    end
  end
end

VersionsController.send :prepend, RedmineCustomWorkflows::Patches::Controllers::VersionsControllerPatch