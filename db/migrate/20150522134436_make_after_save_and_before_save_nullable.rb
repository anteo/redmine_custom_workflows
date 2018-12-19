class MakeAfterSaveAndBeforeSaveNullable < ActiveRecord::Migration[4.2]
  def up
    change_column :custom_workflows, :before_save, :text, :null => true, :default => nil
    change_column :custom_workflows, :after_save, :text, :null => true, :default => nil
  end
end
