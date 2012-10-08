module RedmineCustomWorkflows
  module IssuePatch
    unloadable

    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        before_save :before_save_custom_workflows
        after_save :after_save_custom_workflows
        validate :validate_status
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

      def run_custom_workflows(on)
        return true unless project
        workflows = project.enabled_custom_workflows
        return true unless workflows.any?
        @issue = self # compatibility with 0.0.1
        Rails.logger.info "= Running #{on} custom workflows for issue \"#{subject}\" (##{id})"
        workflows.each do |workflow|
          begin
            Rails.logger.info "== Running #{on} custom workflow \"#{workflow.name}\""
            instance_eval(workflow.read_attribute(on))
          rescue WorkflowError => e
            Rails.logger.info "== User workflow error: #{e.message}"
            errors.add :base, e.error
            return false
          rescue Exception => e
            Rails.logger.error "== Custom workflow exception: #{e.message}\n #{e.backtrace.join("\n ")}"
            errors.add :base, :custom_workflow_error
            return false
          end
        end
        Rails.logger.info "= Finished running #{on} custom workflows for issue \"#{subject}\" (##{id})."
        true
      end

      def before_save_custom_workflows
        @saved_attributes = attributes.dup
        result = run_custom_workflows(:before_save) && (@saved_attributes == attributes || valid?)
        @saved_attributes = nil
        result
      end

      def after_save_custom_workflows
        run_custom_workflows(:after_save)
      end
    end
  end
end
