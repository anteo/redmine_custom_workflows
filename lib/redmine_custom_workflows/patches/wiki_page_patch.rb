# encoding: utf-8
#
# Redmine plugin for Custom Workflows
#
# Copyright Anton Argirov
# Copyright Karel Pičman <karel.picman@kontron.com>
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
    module WikiPagePatch

      def self.included(base)
        base.class_eval do
          def self.attachments_callback(event, page, attachment)
            page.instance_variable_set(:@page, page)
            page.instance_variable_set(:@attachment, attachment)
            CustomWorkflow.run_shared_code(page) if event.to_s.starts_with? 'before_'
            CustomWorkflow.run_custom_workflows(:wiki_page_attachments, page, event)
          end

          [:before_add, :before_remove, :after_add, :after_remove].each do |observable|
            send("#{observable}_for_attachments") << lambda { |event, page, attachment| WikiPage.attachments_callback(event, page, attachment) }
          end
        end
      end

    end
  end
end

# Apply patch
RedmineExtensions::PatchManager.register_model_patch 'WikiPage',
  'RedmineCustomWorkflows::Patches::WikiPagePatch'