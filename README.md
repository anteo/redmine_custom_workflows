Custom Workflows plug-in 2.0.5 devel
====================================

![GitHub Action](https://github.com/antoneo/redmine_custom_workflows/actions/workflows/rubyonrails.yml/badge.svg?branch=devel)
[![Support Ukraine Badge](https://bit.ly/support-ukraine-now)](https://github.com/support-ukraine/support-ukraine)

This plug-in provides a great functionality for those who is familiar with the Ruby language.
It allows to customize workflow by defining own rules for issues processing. It's possible:
* To change issue properties if some conditions are met.
* To create new issues programmatically, if the conditions are met (for example you can create an issue in another project if the status of source issue is changed to specific value).
* To raise custom errors which will be displayed to the user, if he does something wrong.
* To do anything that conforms to your needs.

Supported observable objects:
* Issue (before_save, after_save)
* Group (before_save, after_save)
* User (before_save, after_save)
* Group users (before_add, after_add, before_remove, after_remove)
* \<Shared code\>

`<Shared code>` - special type for workflows that running before all other workflows and can provide libraries of additional functions or classes.

Thanks to
---------

The initial development was supported by [DOM Digital Online Media GmbH](https://www.dom.de). The present development is supported by [Kontron](https://www.kontorn.com)

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
systemctl restart apache2
```

Configuration
-------------

First, you need to define your own custom workflow(s). We already included one, called "Duration/Done Ratio/Status correlation". You'll find it after installing the plug-in. It demonstrates some possibilities of plug-in.

Go to the *Administration* section, then select <b>Custom workflows</b>. A list of defined workflows will appear. Here you can create new workflow, update, reorder and delete existing workflows. The order of workflows specifies the order in which workflow scripts will be executed.

Then click the <b>Create a custom workflow</b> button. Enter a short name and full description. Below you will see two textareas. Fill one or both textareas by Ruby-language scripts that will be executed before and after saving the issue (on before_save and after_save callbacks respectively).

Both scripts are executed in the context of the issue. So access properties and methods of the issue directly (or through keyword "self"). You can also raise exceptions by <b>raise RedmineCustomWorkflows::Errors::WorkflowError, "Your message"</b>. If you change some properties of the issue before saving it, it will be revalidated then and additional validation errors can appear.

Enabling custom workflows for projects
-------------------------------

After you defined your custom workflow(s), you need to enable it for particular project(s). There are two ways of doing this.
* While editing existing or creating new custom workflow;
* In project settings (if the user has appropriate permission). Open <b>Project settings</b>. Go to the <b>Custom workflows</b> tab of the project settings and enable workflow(s) you need for this project.

Now go to the *Issues* and test it.

Duration/Done Ratio/Status correlation example
----------------------------------------------

Fill the "before save" script with:

    if done_ratio_changed?
        if done_ratio==100 && status_id==2
          self.status_id=3
        elsif [1,3,4].include?(status_id) && done_ratio<100
          self.status_id=2
        end
    end
    
    if status_id_changed?
        if status_id==2
          self.start_date ||= Time.now
        end
        if status_id==3
          self.done_ratio = 100
          self.start_date ||= created_on
          self.due_date ||= Time.now
        end
    end

Example of creating subtask if the issue's status has changed
-------------------------------------------------------------

Fill the "before save" script with:

    @need_create = status_id_changed? && !new_record?

Fill the "after save" script with:

    if @need_create
        issue = Issue.new(
          :author => User.current,
          :project => project,
          :tracker => tracker,
          :assigned_to => author,
          :parent_issue_id => id,
          :subject => "Subtask",
          :description => "Description")
        
        issue.save!
    end

Do not forget to check whether issue is just created. Here we create the new issue and newly created issue will also be passed to this script on save. So without check, it will create another sub-issue. And etc. Thus it will fall into infinite recursion.

Compatibility
-------------

This plug-in is compatible with Redmine 4.1.x., 4.2.x. and 5.0.x.
