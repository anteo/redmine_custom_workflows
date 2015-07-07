module RedmineCustomWorkflows
  module GroupPatch

    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        before_save :before_save_custom_workflows
        after_save :after_save_custom_workflows

        def self.users_callback(event, group, user)
          group.instance_variable_set(:@group, group)
          group.instance_variable_set(:@user, user)
          CustomWorkflow.run_shared_code(group) if event.to_s.starts_with? 'before_'
          CustomWorkflow.run_custom_workflows(:group_users, group, event)
        end
        if Rails::VERSION::MAJOR >= 4
          callback_lambda = lambda { |event, group, user| Group.users_callback(event, group, user) }
          before_add_for_users << callback_lambda
          before_remove_for_users << callback_lambda
          after_add_for_users << callback_lambda
          after_remove_for_users << callback_lambda
        else
          before_add_for_users << lambda { |group, user| Group.users_callback(:before_add, group, user) }
          before_remove_for_users << lambda { |group, user| Group.users_callback(:before_remove, group, user) }
          after_add_for_users << lambda { |group, user| Group.users_callback(:after_add, group, user) }
          after_remove_for_users << lambda { |group, user| Group.users_callback(:after_remove, group, user) }
        end
      end
    end

    module InstanceMethods
      def before_save_custom_workflows
        @group = self
        @saved_attributes = attributes.dup
        CustomWorkflow.run_shared_code(self)
        CustomWorkflow.run_custom_workflows(:group, self, :before_save)
        errors.empty? && (@saved_attributes == attributes || valid?)
      ensure
        @saved_attributes = nil
      end

      def after_save_custom_workflows
        CustomWorkflow.run_custom_workflows(:group, self, :after_save)
      end
    end
  end
end
