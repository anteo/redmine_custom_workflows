class AddAdditionalScriptFieldsToCustomWorkflows < ActiveRecord::Migration
  def change
    add_column :custom_workflows, :shared_code, :text, :null => true
    add_column :custom_workflows, :before_add, :text, :null => true
    add_column :custom_workflows, :after_add, :text, :null => true
    add_column :custom_workflows, :before_remove, :text, :null => true
    add_column :custom_workflows, :after_remove, :text, :null => true
  end
end
