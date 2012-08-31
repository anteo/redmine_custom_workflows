class ChangeCustomWorkflowsDescriptionType < ActiveRecord::Migration
  def self.up
    change_column :custom_workflows, :description, :text, :null => false
  end

  def self.down
    change_column :custom_workflows, :description, :string, :null => false
  end
end
