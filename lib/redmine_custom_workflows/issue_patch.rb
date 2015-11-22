module RedmineCustomWorkflows
  module IssuePatch

    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        before_save :before_save_custom_workflows
        after_save :after_save_custom_workflows
        before_destroy :before_destroy_custom_workflows
        after_destroy :after_destroy_custom_workflows
        validate :validate_status

        def self.attachments_callback(event, issue, attachment)
          issue.instance_variable_set(:@issue, issue)
          issue.instance_variable_set(:@attachment, attachment)
          CustomWorkflow.run_shared_code(issue) if event.to_s.starts_with? 'before_'
          CustomWorkflow.run_custom_workflows(:issue_attachments, issue, event)
        end

        [:before_add, :before_remove, :after_add, :after_remove].each do |observable|
          send("#{observable}_for_attachments") << if Rails::VERSION::MAJOR >= 4
                                                     lambda { |event, issue, attachment| Issue.attachments_callback(event, issue, attachment) }
                                                   else
                                                     lambda { |issue, attachment| Issue.attachments_callback(observable, issue, attachment) }
                                                   end
        end
      end
    end

    module InstanceMethods
      def validate_status
        return true unless @saved_attributes && @saved_attributes['status_id'] != status_id &&
            !new_statuses_allowed_to(User.current, new_record?).collect(&:id).include?(status_id)

        status_was = IssueStatus.find_by_id(status_id_was)
        status_new = IssueStatus.find_by_id(status_id)

        errors.add :status, :new_status_invalid,
                   :old_status => status_was && status_was.name,
                   :new_status => status_new && status_new.name
      end

      def before_save_custom_workflows
        @issue = self
        @saved_attributes = attributes.dup
        CustomWorkflow.run_shared_code(self)
        CustomWorkflow.run_custom_workflows(:issue, self, :before_save)
        errors.empty? && (@saved_attributes == attributes || valid?)
      ensure
        @saved_attributes = nil
      end

      def after_save_custom_workflows
        CustomWorkflow.run_custom_workflows(:issue, self, :after_save)
      end

      def before_destroy_custom_workflows
        CustomWorkflow.run_custom_workflows(:issue, self, :before_destroy)
      end

      def after_destroy_custom_workflows
        CustomWorkflow.run_custom_workflows(:issue, self, :after_destroy)
      end
    end
  end
end
