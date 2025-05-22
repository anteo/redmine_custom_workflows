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

# SQLite boolean migration
class ChangeDefaultActiveBooleanValueToCustomWorkflows < ActiveRecord::Migration[4.2]
  def up
    return unless ActiveRecord::Base.connection.adapter_name.match?(/sqlite/i)

    change_column_default :custom_workflows, :active, from: true, to: 1
    CustomWorkflow.where(active: 't').update_all active: 1
    CustomWorkflow.where(active: 'f').update_all active: 0
  end

  def down
    return unless ActiveRecord::Base.connection.adapter_name.match?(/sqlite/i)

    change_column_default :custom_workflows, :active, from: 1, to: true
    CustomWorkflow.where(active: 1).update_all active: 't'
    CustomWorkflow.where(active: 0).update_all active: 'f'
  end
end
