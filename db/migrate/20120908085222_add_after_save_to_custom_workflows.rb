class AddAfterSaveToCustomWorkflows < ActiveRecord::Migration
  def self.up
    rename_column :custom_workflows, :script, :before_save
    change_column :custom_workflows, :before_save, :text, :null => false, :default => ""
    add_column :custom_workflows, :after_save, :text, :null => false, :default => "", :after => :before_save
  end
  def self.down
    remove_column :custom_workflows, :after_save
    rename_column :custom_workflows, :before_save, :script
  end
end
