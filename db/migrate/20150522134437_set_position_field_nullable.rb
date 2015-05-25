class SetPositionFieldNullable < ActiveRecord::Migration
  def self.up
    change_column :custom_workflows, :position, :integer, :null => true
  end
  def self.down
  end
end
