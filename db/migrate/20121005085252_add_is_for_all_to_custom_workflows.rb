class AddIsForAllToCustomWorkflows < ActiveRecord::Migration[4.2]
  def change
    add_column :custom_workflows, :is_for_all, :boolean, :null => false, :default => false
  end
end
