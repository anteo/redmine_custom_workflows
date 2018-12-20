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

class AddAfterSaveToCustomWorkflows < ActiveRecord::Migration[4.2]

  def up
    rename_column :custom_workflows, :script, :before_save
    change_column :custom_workflows, :before_save, :text, :null => true
    add_column :custom_workflows, :after_save, :text, :null => true, :after => :before_save
  end

  def down
    remove_column :custom_workflows, :after_save
    rename_column :custom_workflows, :before_save, :script
  end

end
