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

class CreateExampleWorkflow < ActiveRecord::Migration[4.2]

  def up
    CustomWorkflow.reset_column_information
    name = 'Duration/Done Ratio/Status correlation'
    old = CustomWorkflow.where(name: name).first
    old.destroy if old
    cw = CustomWorkflow.new
    cw.name = name
    cw.author = 'anton.argirov@gmail.com'
    cw.description = %{
      Set up a correlation between the start date, due date, done ratio and status of issues.

      * If done ratio is changed to 100% and status is "In Process", status changes to "Resolved"
      * If status is "New", "Resolved" or "Feedback" and done ratio is changed to value less than 100%, status changes to "In process"
      * If status is changed to "In process" and start date is not set, then it sets to current date
      * If status is changed to "Resolved" and end date is not set, then it set to due date

      To use this script properly, turn off "Use current date as start date for new issues" option in the settings as this script already do it own way.
    }
    cw.before_save = %{
      if @issue.done_ratio_changed?
        if (@issue.done_ratio == 100) && (@issue.status_id == 2)
          @issue.status_id = 3
        elsif [1,3,4].include?(@issue.status_id) && (@issue.done_ratio < 100)
          @issue.status_id = 2
        end
      end

      if @issue.status_id_changed?
        if @issue.status_id == 2
          @issue.start_date ||= Time.now
        end
        if @issue.status_id == 3
          @issue.done_ratio = 100
          @issue.start_date ||= @issue.created_on
          @issue.due_date ||= Time.now
        end
      end
    }
    cw.save!
  end

end
