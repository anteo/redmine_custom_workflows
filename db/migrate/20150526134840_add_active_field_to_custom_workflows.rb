class AddActiveFieldToCustomWorkflows < ActiveRecord::Migration[4.2]
  def change
    add_column :custom_workflows, :active, :boolean, :null => false, :default => true
  end
end
