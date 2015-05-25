class AddAuthorAndTimestampsToCustomWorkflows < ActiveRecord::Migration
  def self.up
    add_column :custom_workflows, :author, :string, :null => true
    add_timestamps :custom_workflows
  end
  def self.down
    remove_column :custom_workflows, :author
    remove_timestamps :custom_workflows
  end
end
