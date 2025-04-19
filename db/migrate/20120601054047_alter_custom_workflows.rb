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

# Modify the table
class AlterCustomWorkflows < ActiveRecord::Migration[4.2]
  def up
    change_table(:custom_workflows, bulk: true) do |t|
      t.remove_index :project_id
      t.remove :project_id
      t.remove :is_enabled
      t.string :name, null: false, default: ''
      t.string :description, :string, null: false, default: ''
      t.integer :position, :integer, null: false, default: 1
    end
  end

  def down
    change_table(:custom_workflows, bulk: true) do |t|
      t.references :project
      t.index :project_id, unique: true
      t.boolean :is_enabled, null: false, default: false
      t.remove :name
      t.remove :description
      t.remove :position
    end
  end
end
