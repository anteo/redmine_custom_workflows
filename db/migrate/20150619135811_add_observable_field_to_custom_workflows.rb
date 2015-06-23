class AddObservableFieldToCustomWorkflows < ActiveRecord::Migration
  def change
    add_column :custom_workflows, :observable, :string, :null => false, :default => 'issue'
  end
end
