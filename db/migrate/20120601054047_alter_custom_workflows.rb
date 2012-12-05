class AlterCustomWorkflows < ActiveRecord::Migration
  def self.up
    remove_column :custom_workflows, :project_id
    remove_column :custom_workflows, :is_enabled
    add_column :custom_workflows, :name, :string, :null => false, :default => ""
    add_column :custom_workflows, :description, :string, :null => false, :default => ""
    add_column :custom_workflows, :position, :integer, :null => false, :default => 1
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
