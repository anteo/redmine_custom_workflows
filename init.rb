require 'redmine'

Redmine::Plugin.register :redmine_custom_workflows do
  name 'Redmine Custom Workflow plugin'
  author 'Anton Argirov'
  description 'Allows to create custom workflows for issues, defined in the plain Ruby language'
  version '0.1.6'
  url 'http://www.redmine.org/plugins/custom-workflows'

  requires_redmine version_or_higher: '4.0.0'

  menu :admin_menu, :custom_workflows, {:controller => 'custom_workflows', :action => 'index'},
       :if => Proc.new { User.current.admin? }, :caption => :label_custom_workflow_plural,
	:html => {:class => 'icon icon-workflows'}

  permission :manage_project_workflow, {}, :require => :member
end

require 'redmine_custom_workflows/hooks'

require File.dirname(__FILE__) + '/lib/redmine_custom_workflows/projects_helper_patch'

Rails.application.config.to_prepare do
  unless Project.include?(RedmineCustomWorkflows::ProjectPatch)
    Project.send(:include, RedmineCustomWorkflows::ProjectPatch)
  end
  unless Attachment.include?(RedmineCustomWorkflows::AttachmentPatch)
    Attachment.send(:include, RedmineCustomWorkflows::AttachmentPatch)
  end
  unless Issue.include?(RedmineCustomWorkflows::IssuePatch)
    Issue.send(:include, RedmineCustomWorkflows::IssuePatch)
  end
  unless User.include?(RedmineCustomWorkflows::UserPatch)
    User.send(:include, RedmineCustomWorkflows::UserPatch)
  end
  unless Group.include?(RedmineCustomWorkflows::GroupPatch)
    Group.send(:include, RedmineCustomWorkflows::GroupPatch)
  end
  unless TimeEntry.include?(RedmineCustomWorkflows::TimeEntryPatch)
    TimeEntry.send(:include, RedmineCustomWorkflows::TimeEntryPatch)
  end
  unless Version.include?(RedmineCustomWorkflows::VersionPatch)
    Version.send(:include, RedmineCustomWorkflows::VersionPatch)
  end
  unless WikiContent.include?(RedmineCustomWorkflows::WikiContentPatch)
    WikiContent.send(:include, RedmineCustomWorkflows::WikiContentPatch)
  end
  unless WikiPage.include?(RedmineCustomWorkflows::WikiPagePatch)
    WikiPage.send(:include, RedmineCustomWorkflows::WikiPagePatch)
  end
  unless Mailer.include?(RedmineCustomWorkflows::MailerPatch)
    Mailer.send(:include, RedmineCustomWorkflows::MailerPatch)
  end
  unless ActionView::Base.include?(RedmineCustomWorkflows::Helper)
    ActionView::Base.send(:include, RedmineCustomWorkflows::Helper)
  end
end
