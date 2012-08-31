class CreateCustomWorkflowsProjects < ActiveRecord::Migration
  def self.up
    create_table :custom_workflows_projects, :force => true, :id => false do |t|
      t.references :project
      t.references :custom_workflow
    end
    add_index :custom_workflows_projects, [:project_id]
    add_index :custom_workflows_projects, [:custom_workflow_id]
  end

  def self.down
    drop_table :custom_workflows_projects
  end
end
