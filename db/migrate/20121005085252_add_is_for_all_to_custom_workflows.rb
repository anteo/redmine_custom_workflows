class AddIsForAllToCustomWorkflows < ActiveRecord::Migration
  def self.up
    add_column :custom_workflows, :is_for_all, :boolean, :null => false, :default => false
  end
  def self.down
    remove_column :custom_workflows, :is_for_all
  end
end
