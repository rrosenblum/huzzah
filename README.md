# Huzzah

Huzzah is a role-centric test automation framework designed to the used in conjunction with Watir-WebDriver. While there are many aspects to role-based testing, it can be broken down to a few concepts:

1. Test scenarios where multiple roles (or users) interact with each other.
2. Test sceanrios that require a role with specific permissions (e.g. an admin).
3. Test scenarios that require a role with specific attributes (e.g. a user with a suspended account).

Huzzah is designed to make this type of testing easier and more manageable. In addition role manangement, the framework implements standard features like page-objects, application flows & site configuration. 

Huzzah takes a define and use approach, which means that it does a lot of the work for you. It allows you to focus on writing better tests while it dynamically handles the linkage of objects that you have defined.

## Installation

Add these line to your application's Gemfile:

```ruby
gem 'huzzah'
gem 'watir-webdriver'
```

NOTE: While Huzzah is designed to be used in conjunction with Watir-WebDriver, the two gems are decoupled. This also you to
 choose which version of of Watir-WebDriver best suits your needs.

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install huzzah
    $ gem install watir-webdriver

## Basic Usage

```ruby
require 'huzzah'
 require 'watir-webdriver'

@role = Huzzah::Role.new
 @role.browser.goto('http://www.google.com')
puts @role.browser.title
@role.browser.close
```

## Advanced Usage


## Contributing

1. Fork it ( https://github.com/[my-github-username]/huzzah/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Authors

Lance Howard https://github.com/lkhoward

Umair Chagani https://github.com/uchagani
