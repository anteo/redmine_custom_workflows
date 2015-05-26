class AddActiveFieldToCustomWorkflows < ActiveRecord::Migration
  def change
    add_column :custom_workflows, :active, :boolean, :null => false, :default => true
  end
end
