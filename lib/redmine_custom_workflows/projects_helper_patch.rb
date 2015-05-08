module RedmineCustomWorkflows
  module ProjectsHelperPatch

    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        alias_method_chain :project_settings_tabs, :custom_workflows
      end
    end

    module InstanceMethods
      def project_settings_tabs_with_custom_workflows
        tabs = project_settings_tabs_without_custom_workflows
        tabs << {:name => 'custom_workflows', :action => :manage_project_workflow, :partial => 'projects/settings/custom_workflow',
                 :label => :label_custom_workflow_plural} if User.current.allowed_to?(:manage_project_workflow, @project)
        tabs
      end
    end
  end
end