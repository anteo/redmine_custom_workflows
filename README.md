Custom Workflows plug-in 3.0.0
==============================

[![GitHub CI](https://github.com/anteo/redmine_custom_workflows/actions/workflows/rubyonrails.yml/badge.svg?branch=master)](https://github.com/anteo/redmine_custom_workflows/actions/workflows/rubyonrails.yml)
[![Support Ukraine Badge](https://bit.ly/support-ukraine-now)](https://github.com/support-ukraine/support-ukraine)

This plug-in provides a great functionality for those who is familiar with the Ruby language.
It allows to customize workflow by defining own rules for issues processing. It's possible:

* To change issue properties if some conditions are met.
* To create new issues programmatically, if the conditions are met (for example you can create an issue in another 
project if the status of source issue is changed to specific value).
* To raise custom errors which will be displayed to the user, if he does something wrong.
* To do anything that conforms to your needs.

Supported observable objects:

* Attachment
* Group
* Issue
* Issue relations
* Time entry
* User
* Member
* Version
* Wiki
* \<Shared code\>

`<Shared code>` - a special type for workflows that are running before all other workflows and can provide libraries of 
additional functions or classes.

Thanks to
---------

The initial development was supported by [DOM Digital Online Media GmbH](https://www.dom.de). The present development 
is supported by [Kontron](https://www.kontron.com)

Getting help
------------

Create an issue if you want to propose a feature or report a bug:

https://github.com/anteo/redmine_custom_workflows/issues

Check Wiki for examples and programming hints:

https://github.com/anteo/redmine_custom_workflows/wiki

Check this repo with some tested in work custom workflows:

https://github.com/VoronyukM/custom-workwlows

Installation
------------

From a ZIP file:

* Download the latest version of the plugin.
* In case of an upgrade, remove the original *plugins/redmine_custom_workflows* folder.
* Unzip it to /plugins.

From the Git repository:

* Clone  the repository:

```shell
cd redmine/plugins
git clone https://github.com/anteo/redmine_custom_workflows.git
```

After download:

* Run migrations and restart the application:

```shell
cd redmine
bundle install
RAILS_ENV=production bundle exec rake redmine:plugins:migrate NAME=redmine_custom_workflows
RAILS_ENV=production bundle exec rake assets:precompile
chown -R www-data:www-data redmine
systemctl restart apache2
```

Configuration
-------------

First, you need to define your own custom workflow(s). We already included one, called "Duration/Done Ratio/Status 
correlation". You'll find it after installing the plug-in. It demonstrates some possibilities of the plug-in.

Go to the **_Administration_** section, then select **_Custom workflows_**. A list of defined workflows will appear. Here 
you can create a new workflow, update, reorder or delete the existing workflows. The order of workflows specifies the 
order in which the workflow scripts will be executed.

Then click the **Create a custom workflow** button. Enter a short name and full description. Below you will see two text 
areas. Fill one or both text areas with Ruby-language scripts that will be executed before and after saving the issue 
(on _before_save_ and _after_save_ callbacks respectively).

Both scripts are executed in the context of the issue. So, access properties and methods of the issue directly (or 
through keyword `self`). You can also raise exceptions by raising `RedmineCustomWorkflows::Errors::WorkflowError` exception. 
If you change some properties of the issue before saving it, it will be revalidated then and additional validation errors 
can appear.

E.g.:

```ruby
  raise RedmineCustomWorkflows::Errors::WorkflowError, 'Your message'
```

You can also display an info/warning/error message to the user using an observed object property `custom_workflow_messages`.

E.g.:

```ruby
  self.custom_workflow_messages[:notice] = 'Custom workflow info'
  self.custom_workflow_messages[:warning] = 'Custom workflow warning'
  self.custom_workflow_messages[:error] = 'Custom workflow error'
```

Some environmental variables are available in observable objects.

E.g.:

```ruby
self.custom_workflow_env[:remote_ip]
```

An email can be sent from within a script.

E.g.:

```ruby
CustomWorkflowMailer.deliver_custom_email(user, subject: subject, text_body: text)
```

Enabling custom workflows for projects
--------------------------------------

After you defined your custom workflow(s), you need to enable it for particular project(s). (This is valid for project 
related observable objects.) There are two ways of doing 
this.
* While editing existing or creating a new custom workflow;
* In the project's settings (if the user has appropriate permission). Open **_Project settings_**. Go to 
**_Custom workflows_** tab of the project's settings and enable those workflows you need for this project.

Now go to the **_Issues_** and test it.

Examples
--------

### Duration/Done Ratio/Status correlation example

Fill the "before save" script with:

```ruby
if done_ratio_changed?
    if (done_ratio == 100) && (status_id == 2)
      self.status_id = 3
    elsif [1,3,4].include?(status_id) && (done_ratio < 100)
      self.status_id = 2
    end
end

if status_id_changed?
    if (status_id == 2)
      self.start_date ||= Time.now
    end
    if (status_id == 3)
      self.done_ratio = 100
      self.start_date ||= created_on
      self.due_date ||= Time.now
    end
end
```

### Example of creating subtask if the issue's status has changed

Fill the "before save" script with:

```ruby
@need_create = status_id_changed? && !new_record?
```

Fill the "after save" script with:

```ruby
if @need_create
    issue = Issue.new(
      author: User.current,
      project: project,
      tracker: tracker,
      assigned_to: author,
      parent_issue_id: id,
      subject: 'Subtask',
      description: 'Description')
    issue.save!
end
```

Do not forget to check whether the issue is just created. Here, we create a new issue and newly created issue will also 
be passed to this script on save event. So, without a check, it will create another sub-issue. And so on. Thus, it will 
fall into infinite loop.

Compatibility
-------------

Redmine 6.x required.
