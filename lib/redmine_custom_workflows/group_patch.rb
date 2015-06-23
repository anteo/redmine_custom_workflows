module RedmineCustomWorkflows
  module GroupPatch

    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        before_save :before_save_custom_workflows
        after_save :after_save_custom_workflows

        callback = lambda do |event, group, user|
          group.instance_variable_set(:@group, group)
          group.instance_variable_set(:@user, user)
          CustomWorkflow.run_shared_code(group) if event.to_s.starts_with? 'before_'
          CustomWorkflow.run_custom_workflows(:group_users, group, event)
        end

        before_add_for_users << callback
        before_remove_for_users << callback
        after_add_for_users << callback
        after_remove_for_users << callback
      end
    end

    module InstanceMethods
      def before_save_custom_workflows
        @group = self
        @saved_attributes = attributes.dup
        CustomWorkflow.run_shared_code(self)
        result = CustomWorkflow.run_custom_workflows(:group, self, :before_save) && (@saved_attributes == attributes || valid?)
        @saved_attributes = nil
        result
      end

      def after_save_custom_workflows
        CustomWorkflow.run_custom_workflows(:group, self, :after_save)
      end
    end
  end
end
