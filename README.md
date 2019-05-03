[![Build Status](https://travis-ci.com/manheim/huzzah.svg?branch=master)](https://travis-ci.com/manheim/huzzah)

# Huzzah

Huzzah is a role-centric test automation framework designed to the used in conjunction with Watir. While there are many aspects to role-based testing, it can be broken down to a few concepts:

1. Test scenarios where multiple roles (or users) interact with each other.
2. Test scenarios that require a role with specific permissions (e.g. an admin).
3. Test scenarios that require a role with specific attributes (e.g. a user with a suspended account).

Huzzah is designed to make this type of testing easier and more manageable. In addition role manangement, the framework implements standard features like page-objects, application flows & site configuration.

Huzzah takes a define and use approach, which means that it does a lot of the work for you. It allows you to focus on writing better tests while it dynamically handles the linkage of objects that you have defined.

## Installation

Add these line to your application's Gemfile:

```ruby
gem 'huzzah'
gem 'watir'
```

**NOTE:** While Huzzah is designed to be used in conjunction with Watir, the two gems are decoupled. This also you to
 choose which version of of Watir best suits your needs.

And then execute:
```
$ bundle install
```

Or install it yourself as:
```
$ gem install huzzah
$ gem install watir
```

## Basic Usage

```ruby
require 'huzzah'
require 'watir'

@role = Huzzah::Role.new
@role.browser.goto('http://www.google.com')
puts @role.browser.title
@role.browser.close
```
## Getting Started
Let's assume huzzah library will live under lib/huzzah and we'll configure Huzzah in
features/support/env.rb as:
```ruby
require 'huzzah'
require 'watir-webdriver'
$PROJECT_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '../..'))

Huzzah.configure do |config|
  config.path = "#{PROJECT_ROOT}/lib/huzzah"
  config.default_driver = ENV['BROWSER'] ||= 'firefox'
  config.environment = ENV['AUTO_ENV'] ||= 'test'
end
```

Next let's go ahead and define our sample site in
lib/huzzah/sites/sample_site.yml with two environments

```ruby
test:
  :url: http://localhost:1234/sample-site
ba:
  :url: http://ba-env/sample-site
```

Now we're ready to define the users per environment in
lib/huzzah/roles/user.yml
```ruby
test:
  :username: 'test1'
  :password: 'password-1'

ba:
  :username: 'test2'
  :password: 'password-2'
```

This is optional but If I wanted to define the roles in the Before hook i'd do something like this:
```ruby
Before do
  @user = Huzzah::Role.new(:user) #Note: :user corresponds to lib/huzzah/roles/user.yml
end
```

At this point we can define our test we'll use Cucumber scenario
```ruby
Feature: Basic Search
  As a SampleSite basic user
  In order to find my search results
  I want to utilize a basic search form

  Scenario: User performs basic search
    Given I am a SampleSite basic user
    When I perform a basic search
    Then I should see my basic search results
```

let's define our PageObject classes in lib/huzzah/pages/search_form_page.rb:
```ruby
module SampleSite #Note: module name corresponds to the the name of the site i.e. sample_site and needs to be camel-cased
  class SearchFormPage < Huzzah::Page
    locator(:search)  { button(id: 'search_b_1')}
  end
end
```
and in lib/huzzah/pages/search_results_page.rb
```ruby
module SampleSite #Note: module name corresponds to the the name of the site i.e. sample_site and needs to be camel-cased
  class SearchResultsPage < Huzzah::Page
    locator(:toolbar_full)  { div(id: 'onesearch_toolbar_full') }
  end
end
```


with step definitions which would look like:
```ruby
Given(/^I am a SampleSite basic user$/) do
  @user.visit(:sample_site) #Note: :one_search corresponds to the name of the site yml file i.e. sample_site.yml
end

When(/^I perform a basic search$/) do
  @user.sample_site.search_form_page.search
end

Then(/^I should see my basic search results$/) do
  expect(@user.sample_site.search_results_page.toolbar_full).to exist
end
```



## Advanced Usage
Huzzah implements the page-object pattern, user flows and site configuration across multiple environments. For more information:

Follow the [Tutorial](https://github.com/manheim/huzzah/wiki/Tutorial).

Read the [Wiki](https://github.com/manheim/huzzah/wiki).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/huzzah/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Authors

Lance Howard https://github.com/lkhoward

Umair Chagani https://github.com/uchagani
