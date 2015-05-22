class SetPositionFieldNullable < ActiveRecord::Migration
  def change
    change_column :custom_workflows, :position, :integer, :null => true
  end
end
