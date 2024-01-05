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

# Extend custom workflows table
class AddAdditionalScriptFieldsToCustomWorkflows < ActiveRecord::Migration[4.2]
  def change
    change_table(:custom_workflows, bulk: true) do |t|
      t.text :shared_code, null: true
      t.text :before_add, null: true
      t.text :after_add, null: true
      t.text :before_remove, null: true
      t.text :after_remove, null: true
    end
  end
end
