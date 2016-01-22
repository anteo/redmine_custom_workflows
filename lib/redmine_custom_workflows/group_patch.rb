module RedmineCustomWorkflows
  module GroupPatch

    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        before_save :before_save_custom_workflows
        after_save :after_save_custom_workflows
        before_destroy :before_destroy_custom_workflows
        after_destroy :after_destroy_custom_workflows

        def self.users_callback(event, group, user)
          group.instance_variable_set(:@group, group)
          group.instance_variable_set(:@user, user)
          CustomWorkflow.run_shared_code(group) if event.to_s.starts_with? 'before_'
          CustomWorkflow.run_custom_workflows(:group_users, group, event)
        end
        [:before_add, :before_remove, :after_add, :after_remove].each do |observable|
          send("#{observable}_for_users") << if Rails::VERSION::MAJOR >= 4
                                               lambda { |event, group, user| Group.users_callback(event, group, user) }
                                             else
                                               lambda { |group, user| Group.users_callback(observable, group, user) }
                                             end
        end
      end if CustomWorkflow.table_exists?
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

      def before_destroy_custom_workflows
        CustomWorkflow.run_custom_workflows(:group, self, :before_destroy)
      end

      def after_destroy_custom_workflows
        CustomWorkflow.run_custom_workflows(:group, self, :after_destroy)
      end
    end
  end
end
