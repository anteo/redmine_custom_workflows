module RedmineCustomWorkflows
  module UserPatch

    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        before_save :before_save_custom_workflows
        after_save :after_save_custom_workflows
      end
    end

    module InstanceMethods
      def before_save_custom_workflows
        @user = self
        @saved_attributes = attributes.dup
        CustomWorkflow.run_shared_code(self)
        result = CustomWorkflow.run_custom_workflows(:user, self, :before_save) && (@saved_attributes == attributes || valid?)
        @saved_attributes = nil
        result
      end

      def after_save_custom_workflows
        CustomWorkflow.run_custom_workflows(:user, self, :after_save)
      end
    end
  end
end
