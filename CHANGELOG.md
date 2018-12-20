Changelog for Custom Workflows
==========================


1.0.0
-----

    Redmine 4.0 compatibility

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
