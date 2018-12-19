class AddBeforeAndAfterDestroyToCustomWorkflows < ActiveRecord::Migration[4.2]
  def change
    add_column :custom_workflows, :before_destroy, :text, :null => true
    add_column :custom_workflows, :after_destroy, :text, :null => true
  end
end
