class FixExampleWorkflow < ActiveRecord::Migration
  def self.up
    if workflow = CustomWorkflow.find_by_name("Duration/Done Ratio/Status correlation")
      workflow.before_save = <<EOS
if done_ratio_changed?
  if done_ratio==100 && status_id==2
    self.status_id=3
  elsif [1,3,4].include?(status_id) && done_ratio<100
    self.status_id=2
  end
end

if status_id_changed?
  if status_id==2
    self.start_date ||= Time.now
  end
  if status_id==3
    self.done_ratio = 100
    self.start_date ||= created_on
    self.due_date ||= Time.now
  end
end
EOS
      workflow.save
    end
  end

  def self.down
  end
end
