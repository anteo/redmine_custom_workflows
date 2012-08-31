module RedmineCustomWorkflows
  module IssuePatch
    unloadable

    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        before_save :custom_workflow_eval
        validate :validate_status
      end
    end

    module InstanceMethods
      def validate_status
        if status_id_was != status_id && !new_statuses_allowed_to(User.current, new_record?).collect(&:id).include?(status_id)
          status_was = IssueStatus.find_by_id(status_id_was)
          status_new = IssueStatus.find_by_id(status_id)

          errors.add :status, :new_status_invalid,
                     :old_status => status_was && status_was.name,
                     :new_status => status_new && status_new.name
        end
      end

      def custom_workflow_eval
        return true unless project && project.module_enabled?(:custom_workflows_module)
        saved_attributes = attributes.dup
        project.custom_workflows.each do |workflow|
          begin
            workflow.eval_script(:issue => self)
          rescue WorkflowError => e
            errors.add :base, e.error
            return false
          rescue Exception => e
            Rails.logger.warn e
            errors.add :base, :custom_workflow_error
            return false
          end
        end
        saved_attributes == attributes || valid?
      end
    end
  end
end
