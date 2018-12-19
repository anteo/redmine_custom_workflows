class ChangeCustomWorkflowsDescriptionType < ActiveRecord::Migration[4.2]
  def self.up
    change_column :custom_workflows, :description, :text, :null => true, :default => nil
  end

end
