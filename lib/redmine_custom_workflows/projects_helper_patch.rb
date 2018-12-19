module RedmineCustomWorkflows
  module ProjectsHelperPatch

    def project_settings_tabs
      tabs = super 
      tabs << {:name => 'custom_workflows', :action => :manage_project_workflow, :partial => 'projects/settings/custom_workflow',
               :label => :label_custom_workflow_plural} if User.current.allowed_to?(:manage_project_workflow, @project)
      tabs
    end

  end
end

ProjectsHelper.send(:prepend, RedmineCustomWorkflows::ProjectsHelperPatch)
