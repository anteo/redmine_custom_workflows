class AddAuthorAndTimestampsToCustomWorkflows < ActiveRecord::Migration
  def change
    add_column :custom_workflows, :author, :string, :null => true
    add_timestamps :custom_workflows
  end
end
