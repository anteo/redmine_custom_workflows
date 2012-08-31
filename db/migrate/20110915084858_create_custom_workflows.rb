class CreateCustomWorkflows < ActiveRecord::Migration
  def self.up
    create_table :custom_workflows, :force => true do |t|
      t.references :project
      t.text :script
      t.boolean :is_enabled
    end
    add_index :custom_workflows, [:project_id], :unique => true
  end

  def self.down
    drop_table :custom_workflows
  end
end
