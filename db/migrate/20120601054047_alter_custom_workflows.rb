# encoding: utf-8
#
# Redmine plugin for Custom Workflows
#
# Copyright © 2015-19 Anton Argirov
# Copyright © 2019-23 Karel Pičman <karel.picman@kontron.com>
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

class AlterCustomWorkflows < ActiveRecord::Migration[4.2]

  def self.up
    remove_column :custom_workflows, :project_id
    remove_column :custom_workflows, :is_enabled
    add_column :custom_workflows, :name, :string, null: false, default: ''
    add_column :custom_workflows, :description, :string, null: false, default: ''
    add_column :custom_workflows, :position, :integer, null: false, default: 1
  end

end
