Changelog for Custom Workflows
==============================

2.1.1 *????-??-??*
------------------

IMPORTANT: Parameters of *CustomWorkflowMailer.deliver_custom_email* method has changed.

before: `CustomWorkflowMailer.deliver_custom_email(user, subject, text)`

now: `CustomWorkflowMailer.deliver_custom_email(user, headers = {})`

To achieve the same behaviour you have to modify an existing callig as follows

`CustomWorkflowMailer.deliver_custom_email(user, subject: subject, text_body: text)`

2.1.0 *2023-11-15*
------------------
    Member as an observable object
    Redmine 5.1 compatibility

* New: #324 - Add Member as a observable object
* Bug: #322 - Problem with upgrading from 2.0.3 to 2.0.9
* New: #320 - Interference with other redmine-plugins

2.0.9 *2023-06-06*
------------------
    More robust XML import
    Rubocop tests of plugin's source codes

2.0.8 *2023-02-10*
------------------
    Better error log messages

* New: #295 - production.log 

2.0.7 *2022-11-09*
------------------
    Bug fix

* Bug: #285 - Viewing wiki version raises a error

2.0.6 *2022-11-01*
------------------
    Flash messages

* Bug: #281 - Internal error 500
* New: #280 - Q: check for REST API access (user impersonation or remote IP) in workflow
* New: #275 - When using Before Destruction on issues, no error gets displayed
* New: #85  - Preventing issue attachments to be deleted
* New: #39  - Ability to raise a warning or info (similar to raise WorkflowError, “Your message”)

2.0.5 *2022-09-20*
------------------
    GitHub CI

2.0.4 *2022-06-24*
------------------
    Maintenance release

* Bug: #261 - Uninitialized constant CustomWorkflow::WorkflowError

2.0.3 *2022-05-26*
------------------
    Redmine 4.2 compatibility

* Bug: #260 - Upgrade from 1.0.4 to 2.0.2, has an error, redmine 4.2.3 to 4.2.6

2.0.2 *2022-05-18*
------------------
    Ruby 3.0 compatibility

* Bug: #258 - Tried to create Proc object without a block (again and better)

2.0.1 *2022-05-13*
------------------
    Ruby 2.7 backward compatibility

* Bug: #257 - IssueRelation.to_s is broken after #257 bug
* Bug: #258 - Tried to create Proc object without a block 

2.0.0 *2022-04-27*
------------------
    Redmine 5.0

* New: #255 - Can you update it to Redmine 5.0.0
* New: #252 - Rails 6
* Bug: #248 - Redmine 4.2.3 doesn't start after installing custom workflow plugin
* New: #239 - Gitlab CI enhancement

1.0.7 *2021-10-20*
------------------
    Spanish localisation

1.0.6 *2021-10-08*
------------------
    Maintenance release

1.0.5 *2021-04-30*
------------------
    SQLite 3 compatibility

* Bug: #204 - Rails 4: sqlite3 t/f -> 1/0

1.0.4 *2020-11-25*
------------------
    Maintenance release
    
* Bug: #193 - Error after install on fresh 4.1.1
* New: #190 - Execute workflows in order of their positioning
* New: #189 - Enable custom workflows for issue relations
* New: #183 - Add link to repo with some examples    

1.0.3 *2020-06-12*
------------------
    Redmine's look&feel
        
* Bug: #168 - Check last version of plugin KO
* Bug: #167 - Crash when delete project

1.0.2 *2020-01-21*
------------------
    Redmine 4.1 compatibility
        
* Bug: #149 - Error install on Redmine 4.1.0
* Bug: #141 - Bug when using PT-BR

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
