# Private Wiki plugin for ChiliProject [![Build Status](https://secure.travis-ci.org/jnv/chiliproject_private_wiki.png?branch=master)](http://travis-ci.org/jnv/chiliproject_private_wiki)

Allows individual wiki pages to be set as private. Private pages are visible only to roles with "View private wiki pages" permission.

## Modifications in this fork

Plugin is based on [Redmine Private Wiki](https://github.com/f0y/redmine_private_wiki) by Oleg Kandaurov.

The main goal of this fork is to provide ChiliProject compatibility and test coverage.

- Privacy is checked for page's ancestors. If a parent page is private, all its descendants will be considered private too.
- Uses jQuery instead of Prototype.

## Installation

1. Follow the instructions at https://www.chiliproject.org/projects/chiliproject/wiki/Plugin_Install
2. Two new permissions will be available for roles: View private wiki pages and Manage private wiki pages (to manage privacy of the page)
3. Page can be changed to private using the contextual links on the wiki page

## Compatibility

Plugin was tested with ChiliProject 3.1.0 and Ruby 1.9.3.

## Testing

Patches, pull requests and forks are welcome, but if possible, provide proper test coverage.

You can also use [Travis-CI](http://travis-ci.org/) integration based on the [chiliproject_test_plugin](https://github.com/jnv/chiliproject_test_plugin).

For running tests, see also [Redmine's instructions](http://www.redmine.org/projects/redmine/wiki/Plugin_Tutorial#Running-test).

Setup and migrate your test database:

```
bundle exec rake db:drop db:create db:migrate redmine:load_default_data db:migrate:plugins RAILS_ENV=test
```

To run tests, execute the following task from main ChiliProject's directory:

```
bundle exec rake test:engines:all PLUGIN=chiliproject_private_wiki
```

You can also execute individual test files, however you need to run this rake task before execution:

```
bundle exec rake test:plugins:setup_plugin_fixtures
```

## License

This plugin is licensed under the MIT license.
