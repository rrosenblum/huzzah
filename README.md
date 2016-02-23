# Huzzah



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

## Basic Usage

```ruby
require 'huzzah'
 require 'watir-webdriver'

@role = Huzzah::Role.new
 @role.browser.goto('http://www.google.com')
puts @role.browser.title
@role.browser.close
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/vinbot/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

