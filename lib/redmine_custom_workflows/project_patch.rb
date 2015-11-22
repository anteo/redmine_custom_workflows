module RedmineCustomWorkflows
  module ProjectPatch

    def self.included(base)
      base.send :include, InstanceMethods
      base.class_eval do
        has_and_belongs_to_many :custom_workflows
        safe_attributes :custom_workflow_ids, :if =>
            lambda { |project, user| project.new_record? || user.allowed_to?(:manage_project_workflow, project) }

        before_save :before_save_custom_workflows
        after_save :after_save_custom_workflows
        before_destroy :before_destroy_custom_workflows
        after_destroy :after_destroy_custom_workflows

        def self.attachments_callback(event, project, attachment)
          project.instance_variable_set(:@project, project)
          project.instance_variable_set(:@attachment, attachment)
          CustomWorkflow.run_shared_code(project) if event.to_s.starts_with? 'before_'
          CustomWorkflow.run_custom_workflows(:project_attachments, project, event)
        end

        [:before_add, :before_remove, :after_add, :after_remove].each do |observable|
          send("#{observable}_for_attachments") << if Rails::VERSION::MAJOR >= 4
                                                     lambda { |event, project, attachment| Project.attachments_callback(event, project, attachment) }
                                                   else
                                                     lambda { |project, attachment| Project.attachments_callback(observable, project, attachment) }
                                                   end
        end
      end
    end

    module InstanceMethods
      def before_save_custom_workflows
        @project = self
        @saved_attributes = attributes.dup
        CustomWorkflow.run_shared_code(self)
        CustomWorkflow.run_custom_workflows(:project, self, :before_save)
        errors.empty? && (@saved_attributes == attributes || valid?)
      ensure
        @saved_attributes = nil
      end

      def after_save_custom_workflows
        CustomWorkflow.run_custom_workflows(:project, self, :after_save)
      end

      def before_destroy_custom_workflows
        CustomWorkflow.run_custom_workflows(:project, self, :before_destroy)
      end

      def after_destroy_custom_workflows
        CustomWorkflow.run_custom_workflows(:project, self, :after_destroy)
      end
    end
  end
end
