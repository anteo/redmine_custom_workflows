class SetPositionFieldNullable < ActiveRecord::Migration
  def up
    change_column :custom_workflows, :position, :integer, :null => true
  end
  def down
  end
end
