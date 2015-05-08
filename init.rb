require 'redmine'
require 'redmine_custom_workflows/hooks'

Rails.application.config.to_prepare do
  unless Project.include?(RedmineCustomWorkflows::ProjectPatch)
    Project.send(:include, RedmineCustomWorkflows::ProjectPatch)
  end
  unless ProjectsHelper.include?(RedmineCustomWorkflows::ProjectsHelperPatch)
    ProjectsHelper.send(:include, RedmineCustomWorkflows::ProjectsHelperPatch)
  end
  unless Issue.include?(RedmineCustomWorkflows::IssuePatch)
    Issue.send(:include, RedmineCustomWorkflows::IssuePatch)
  end
  unless ActionView::Base.include?(RedmineCustomWorkflows::Helper)
    ActionView::Base.send(:include, RedmineCustomWorkflows::Helper)
  end
end

Redmine::Plugin.register :redmine_custom_workflows do
  name 'Redmine Custom Workflow plugin'
  author 'Anton Argirov'
  description 'Allows to create custom workflows for issues, defined in the plain Ruby language'
  version '0.1.0'
  url 'http://redmine.academ.org'

  menu :admin_menu, :custom_workflows, {:controller => 'custom_workflows', :action => 'index'}, :caption => :label_custom_workflow_plural

  permission :manage_project_workflow, {}, :require => :member
end
