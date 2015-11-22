module RedmineCustomWorkflows
  module AttachmentPatch

    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        before_save :before_save_custom_workflows
        after_save :after_save_custom_workflows
        before_destroy :before_destroy_custom_workflows
        after_destroy :after_destroy_custom_workflows
      end
    end

    module InstanceMethods
      def before_save_custom_workflows
        @attachment = self
        @saved_attributes = attributes.dup
        CustomWorkflow.run_shared_code(self)
        CustomWorkflow.run_custom_workflows(:attachment, self, :before_save)
        errors.empty? && (@saved_attributes == attributes || valid?)
      ensure
        @saved_attributes = nil
      end

      def after_save_custom_workflows
        CustomWorkflow.run_custom_workflows(:attachment, self, :after_save)
      end

      def before_destroy_custom_workflows
        CustomWorkflow.run_custom_workflows(:attachment, self, :before_destroy)
      end

      def after_destroy_custom_workflows
        CustomWorkflow.run_custom_workflows(:attachment, self, :after_destroy)
      end
    end
  end
end
