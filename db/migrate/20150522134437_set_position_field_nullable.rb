class SetPositionFieldNullable < ActiveRecord::Migration[4.2]
  def up
    change_column :custom_workflows, :position, :integer, :null => true
  end
end
