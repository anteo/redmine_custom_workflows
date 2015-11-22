class AddBeforeAndAfterDestroyToCustomWorkflows < ActiveRecord::Migration
  def change
    add_column :custom_workflows, :before_destroy, :text, :null => true
    add_column :custom_workflows, :after_destroy, :text, :null => true
  end
end
