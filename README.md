# Excella Feedback Application

## Overview

Excella Consulting's internal application for providing feedback and critiques of company presentations.

#### Who Is It For? ####

The initial target users for this application are those involved in the on-boarding process of new Excellians. This includes the people giving presentations and administrators in addition to the new hires themselves.

#### Why Is It Important? ####

New hires will be able to take surveys about their orientation sessions and presenters can leverage that data to improve the content and teaching of their topics for future classes.

#### What's Next? ####

Down the road, the scope of the feedback app can be expanded from only new hire bootcamps and be used to provide critiques of many more presentations at Excella (and maybe beyond)!

#### Feedback for Feedback ####

In a matter of beautiful irony, if you have feedback for this application (e.g. features that should be implemented, bugs that should be fixed, etc.), please [post an issue][2] to our GitHub Repository.

## Dev Team

#### Getting Set Up ####

  * Fork and/or clone this repo
  * From project directory run:
    * `bundle install`
    * `rake db:create db:migrate` to create database and run migrations
    * _optionally_ `rake db:seed` to seed sample data
  * Run tests using `rake test` or just `rake`
    * Run specific test files using `m test/<path_to_test>`
    * Run specific tests using `m test/<path_to_test>:<line_number>`
  * Run static analysis using `rubocop`
  * Visit the application's [trello][1] board to find a feature to implement
  * Work on your feature, committing code as you go to github
  * Ensure any new feature is well documented and tested
  * Submit a pull request and tag an organizer as well as one of your fellow boot campers as reviewers

#### Technical Info ####

Feedback is built using:
  * Ruby
  * Rails 5.0.1
  * PostgreSQL

## Contributors

The list of contributors below and their role in the project can be contacted with questions about the application (_listed alphabetically by last name_).

  * [Glenn Espinosa](https://www.github.com/gxespino), Product Owner†
  * [Pramod Jacob](https://www.github.com/domarp-j), Developer†
  * [Khoi Le](https://www.github.com/khoitle), Developer†
  * [Drew Nickerson](https://www.github.com/justdroo), Developer†
  * [Nicholas Oki](https://www.github.com/nickoki), Developer†

_†: Denotes member of original scrum team_

[1]: https://trello.com/b/GoACz2aB/excella-feedback-application
[2]:https://github.com/excellaco/excella-feedback/issues
