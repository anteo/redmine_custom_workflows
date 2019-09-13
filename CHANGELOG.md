Changelog for Custom Workflows
==========================

1.0.1 *2019-09-13*
------------------

    Custom emails
        
* Bug: #128 - Undefined method `custom_email`
* Bug: #122 - NameError: uninitialized constant
* Bug: #119 - PostgreSQL querry error

1.0.0
-----

    Redmine 4.0 compatibility
    
* Bug: #116 - raise errors bug
* New: #114 - rails 5
* Bug: #112 - devel 1.0.0 on redmine 4.0.0 problem. bug
* New: #111 - Travis CI help wanted
* New: #109 - Redmine 4.0 compatibility enhancement
* Bug: #89 - Custom workflow for @time_entry doesn't raise on submit of issue form if spent time subform filled bug wontfix
* Bug: #88 - Rendering bug after upgrading to Redmine 3.4.2 bug
* Bug: #63 - Redmine 3.2.1 - Internal Server Error on new Issue with MS SQL bug
* Bug: #60 - Fresh new install on 3.2.2.stable don't work bug
* Bug: #46 - Error in pt-br.yml file bug

0.1.6
-----
 
 * New observable objects added (TimeEntry, Version)
 * Bug fixes
 
0.1.5
-----

* New observable objects added (Project, Wiki Content, Attachment, Issue Attachments, Project Attachments, Wiki Page Attachments)
* Ability to hook before_destroy and after_destroy events

0.1.4
-----

* Ability to exit current workflow with `return` or `return true` and cancel workflow's execution chain with `return false`
* Non-active workflows are now not checked for syntax. Now you can import non-valid (for your Redmine instance for example) workflow, make changes to it and then activate.

0.1.3
-----

* Compatibility with Redmine 2.x.x returned, support of Redmine 1.x.x cancelled

0.1.2
-----
 
 * Added new observable objects. Along with Issue objects you can now watch for changes in User and Group objects
 * Added support of shared workflows - special workflows that running before all other workflows and can provide functions and classes for it
 * Added Mailer helper for sending custom emails from workflows (check Wiki)

0.1.1
-----

* Import/export ability
* Administrator can activate/deactivate workflows globally

0.1.0
-----

* Compatibility with Redmine 3.x, support of Redmine 2.x.x has dropped (for Redmine 2.x.x please use version 0.0.6)

0.0.6
-----

* Import/export ability

0.0.5
-----

* Compatibility with latest versions of Redmine 2.x.x

0.0.4
-----

* Added ability to enable workflows globally for all projects. No need to enable 'Custom workflows' project module anymore. Just go to the 'Administration' -> 'Custom workflows' section and enable or disable your workflows in one place.
* Fixed bug with 'Status transition prohibited' when updating the issue status by the repository commit

0.0.3
-----

* Compatibility with 1.2.x, 1.3.x

0.0.2
-----

* Added ability to define after_save script along with before_save, improved logging, changed context of executing script to the issue.

0.0.1
-----

* Initial commit
