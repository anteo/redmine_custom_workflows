class MakeAfterSaveAndBeforeSaveNullable < ActiveRecord::Migration
  def up
    change_column :custom_workflows, :before_save, :text, :null => true, :default => nil
    change_column :custom_workflows, :after_save, :text, :null => true, :default => nil
  end
  def down
  end
end
