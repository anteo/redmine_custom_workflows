class AddObservableFieldToCustomWorkflows < ActiveRecord::Migration[4.2]
  def change
    add_column :custom_workflows, :observable, :string, :null => false, :default => 'issue'
  end
end
