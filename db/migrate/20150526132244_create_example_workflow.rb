class CreateExampleWorkflow < ActiveRecord::Migration
  def self.up
<<<<<<< HEAD:db/migrate/20120831064944_create_example_workflow.rb
    CustomWorkflow.create(:name => "Duration/Done Ratio/Status correlation", :description => <<EOD, :script => <<EOS)
=======
    CustomWorkflow.reset_column_information
    old = CustomWorkflow.find_by :name => 'Duration/Done Ratio/Status correlation'
    old.destroy if old

    CustomWorkflow.create!(:name => 'Duration/Done Ratio/Status correlation', :author => 'anton.argirov@gmail.com', :description => <<EOD, :before_save => <<EOS)
>>>>>>> 75fa968... #8: fixed crash during migrations on new install:db/migrate/20150526132244_create_example_workflow.rb
Set up a correlation between the start date, due date, done ratio and status of issues.

* If done ratio is changed to 100% and status is "In Process", status changes to "Resolved"
* If status is "New", "Resolved" or "Feedback" and done ratio is changed to value less than 100%, status changes to "In process"
* If status is changed to "In process" and start date is not set, then it sets to current date
* If status is changed to "Resolved" and end date is not set, then it set to due date

To use this script properly, turn off "Use current date as start date for new issues" option in the settings as this script already do it own way.
EOD
if @issue.done_ratio_changed?
  if @issue.done_ratio==100 && @issue.status_id==2
    @issue.status_id=3
  elsif [1,3,4].include?(@issue.status_id) && @issue.done_ratio<100
    @issue.status_id=2
  end
end

if @issue.status_id_changed?
  if @issue.status_id==2
    @issue.start_date ||= Time.now
  end
  if @issue.status_id==3
    @issue.done_ratio = 100
    @issue.start_date ||= @issue.created_on
    @issue.due_date ||= Time.now
  end
end
EOS
  end
end
