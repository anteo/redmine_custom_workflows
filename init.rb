require 'redmine'
require 'redmine_custom_workflows/hooks'

to_prepare = Proc.new do
  unless Project.included_modules.include?(RedmineCustomWorkflows::ProjectPatch)
    Project.send(:include, RedmineCustomWorkflows::ProjectPatch)
  end
  unless ProjectsHelper.included_modules.include?(RedmineCustomWorkflows::ProjectsHelperPatch)
    ProjectsHelper.send(:include, RedmineCustomWorkflows::ProjectsHelperPatch)
  end
  unless Issue.included_modules.include?(RedmineCustomWorkflows::IssuePatch)
    Issue.send(:include, RedmineCustomWorkflows::IssuePatch)
  end
end

if Redmine::VERSION::MAJOR >= 2
  Rails.configuration.to_prepare(&to_prepare)
else
  require 'dispatcher'
  Dispatcher.to_prepare(:redmine_custom_workflows, &to_prepare)
end

Redmine::Plugin.register :redmine_custom_workflows do
  name 'Redmine Custom Workflow plugin'
  author 'Anton Argirov'
  description 'Allows to create custom workflows for issues, defined in the plain Ruby language'
  version '0.0.3'
  url 'http://redmine.academ.org'

  menu :admin_menu, :custom_workflows, {:controller => 'custom_workflows', :action => 'index'}, :caption => :label_custom_workflow_plural

  project_module :custom_workflows_module do
    permission :manage_project_workflow, {}, :require => :member
  end

end
