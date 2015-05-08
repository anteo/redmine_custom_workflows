class ChangeCustomWorkflowsDescriptionType < ActiveRecord::Migration
  def self.up
    change_column :custom_workflows, :description, :text, :null => true, :default => nil
  end

  def self.down
    change_column :custom_workflows, :description, :string, :null => false, :default => ''
  end
end
