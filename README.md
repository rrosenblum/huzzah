huzzah
======

A Flexible Application Modeling Framework for Watir-WebDriver

Huzzah was designed to help you create better page-object models when
dealing with complex websites that consist of multiple web applications.
It really shines when you have web applications (or components) that are shared across
multiple websites or when building test scenarios that require mutilple user roles to be 
interacting through separate browser instances.

Huzzah abstracts your application under test into some basic concepts:

* **Roles** have a browser session
* **Sites** have _Apps_
* **Apps** have _Pages_ 
* **Pages** have _Methods_ and _Partials_
* **Partials** have _Methods_  
* **Flows** define user interactions across your _Sites_ & _Apps_

# Using Huzzah

Add the local gem server to your Gemfile:
```ruby
source 'http://gems.ove.local' 
```

Add the gem to your Gemfile:
```ruby
gem 'huzzah' 
```

# Directory Structure

Your main 'huzzah' directory can be named anything you wish and can exist anywhere within your project. You will 
configure the path to that directory in your Cucumber env.rb or RSpec spec_helper.rb file. 
The directory structure within your main 'huzzah' directory is more rigid. It *must* look
like this:

huzzah/apps

huzzah/apps/[app_name]/pages

huzzah/apps/[app_name]/partials

huzzah/factories <= optional

huzzah/flows

huzzah/models <= optional

huzzah/roles <= optional

huzzah/sites

# Configuration 

Setup your configuration in your Cucumber env.rb or RSpec spec_helper.rb file:

```ruby
Huzzah.configure do |config|
  config.path = "<path to your 'huzzah' directory>"
  config.browser_type = :firefox
  config.environment = 'dev'
end
```

When you configure Huzzah, it will automatically load all of your sites, apps, pages & partials. It will
also load any files in the optional factories, models & roles directories.

# Sites

A **Site** is defined by a YAML file inside the _sites_ directory. It is nothing more than configuration information about the application under test. At a minimum it must contain the URLs for each environment you will be running your tests against. It can also contain other information that may be specific to each environment (e.g. database connection information).

Example: _testsite.yml_
```ruby
---
dev:
  :url: 'http://localhost:9200/index.html'
test:
  :url: 'http://www.testsite-test.com/index.html'  
```
  
Huzzah will maintain the config contained within the YAML file for each site. The site name 
will be the file name without the _.yml_ extension.
 
Using the **Huzzah::DSL** (covered below) you would reference the site like this:
```ruby
# Load the site config and launch a browser:
visit :testsite

# Load the site config without launching a browser:
load_config :testsite

# Reference data in the site config:
site_config.url
# NOTE: The #url method referenced above would return the URL defined in the 
site's YAML file for the correct environment indicated by your Huzzah.config.
```

# Apps

When you define an **App** in Huzzah, it is not tied to any particular _site_. This allows 
you to easily model sites that have shared web applications. For example, you may have a search
engine that is shared across multiple web site.

If you are working with a standalone website, you may only have one _app_ that defines 
your page-objects. But, even if your site doesn't have shared applications, you can use 
_apps_ to logically namespace portions of your site (e.g. search or admin).

To define an _app_, you simply create a directory for it under your **apps** directory. 

A method will be defined within the **Huzzah::DSL** module that references the app.

Each app directory should has two sub-directories _pages_ and _partials_. You will define 
page-objects within the _pages_ directory and partial page-objects within the _partials_ 
directory.


# Page-objects and Partials
 
Create a ruby file for each page that you want to model in your _[appname]/pages_ or 
_[appname]/partials_ directories. The file name used for the page is how Huzzah will 
reference that page. For example, if you have an app called _google_ and a 
page named _search_page.rb_, it will be reference like this:
 
```ruby
google(:search_page)
```
 
or
 
```ruby
google('search_page')
``` 
 
In Huzzah, **Pages** and **Partials** are defined the same way:
  
```ruby
module Google
  class SearchPage < Huzzah::Page

  # define Methods here.

end
```  
NOTE: You should namespace your page-objects based on the name of your apps directory. For example, if you have an app named _goggle_, you should namespace it _module Google_ as in the example above.


# Page Methods

The **Huzzah::Page** class provides a #let method that provides a simple, yet flexible, 
interface for defining methods that interact with the DOM. The #let method takes two 
arguments: a name and a block of Watir-WebDriver code (this syntax should be familiar to those using 
RSpec). The first argument is used to dynamically define a method with that name that will execute the 
code provided in the block.
  
Usage examples:
  
```ruby
module Google
  class SearchPage < Huzzah::Page

  let(:search)                 { button(id: 'search_button').when_present.click }
  let(:results)                { divs(id: /result_/) }
  let(:search_box)             { text_field(id: 'search_terms') }
  let(:current_search_terms)   { search_box.text }
  let(:contains_search_term?)  { |term| current_search_terms.include? term }

end
```  
  
The #let method is intended to be used for short one-liner methods. If you need
to perform multiple actions or complex logic, you can simply define methods within 
the page class:

```ruby
module MyApp
  class HomePage < Huzzah::Page

    let(:set_username)  { |username| text_field(id: "username").when_present.set username }
    let(:set_password)  { |password| text_field(id: "password").when_present.set password }
    let(:login)         { button(value: "Login").click }

    def login_as(username, password)
      set_username username
      set_password password
      login
    end

  end
end
```
  
When defining #let methods, consider whether or not you actually need to return
an instance of an element. 

```ruby
# Using 'element' style. The #let statements are just locators.
my_app(:home_page).user_username.when_present.set 'joseph'
my_app(:home_page).user_password.set 'password'
my_app(:home_page).login_button.click

# Using 'action' style. The #let statements include locators and actions.
my_app(:home_page).set_username 'joseph'
my_app(:home_page).set_password 'password'
my_app(:home_page).login
```

You may also scope element locators within your #let statements:

```ruby
module MyApp
  class HomePage < Huzzah::Page

    let(:login_form)    { form(name: 'login') }
    let(:set_username)  { |username| login_form.text_field(id: "username").when_present.set username }
    
  end
end
```
  
# Page Wrappers
  
In an effort to eliminate boiler-plate code, the **Huzzah::Page** class also handles 
method calls to **Watir::Browser** methods without you having to explicitly reference the 
browser object. As in the example above, you can call:

```ruby
button(id: 'search_button').when_present.click
```
instead of:
```ruby
browser.button(id: 'search_button').when_present.click
```

This works with any method that is part of the **Watir::Browser** class, such as _wait_until_,
_title_, _url_, _html_, _refresh_, etc.

  
# Page Convenience Methods

The **Huzzah::Page** class also contains a few convenience methods:
```ruby   
# Search the page for the specified text
has_text?(text) 
google(:search_page).has_text? 'Foo'

# Alias for #has_text? Meant to be used within page class for better readability.
page_has_text?(text) 

# Waits for ajax calls to complete. Currently only works with jQuery.
wait_for_ajax 
```  
 
# Partials
  
For portions of pages that are shared across multiple pages, you can define a _partial_. 
A _partial_ is simply a _page_ that is pulled into another _page_. 

Example partial:
```ruby
module Google
  class Header < Huzzah::Page

    let(:gmail) { link(text: 'Gmail') }

end  
```  

Pull it into the **Google::Search** page:
```ruby
module Google
  class SearchPage < Huzzah::Page

    partial(:header, Google::Header)

    # Elements, Actions, etc.

end
```
The #partial method takes two arguments: a name and class. The name is used to define a
method on the page that creates a new instance of the partial class.

You can reference the _partial_:
```ruby
google(:search_page).header.gmail.click
```

Within step definitions and flows, Partials can also be referenced directly without
going through a page:
```ruby
google(:header).gmail.click
```

Partials can also used across 'apps'. This feature is intended to be used when modeling complex web applications. For instance, you can pull the Shared header into other applications:
```ruby
module MyApp
  class SearchPage < Huzzah::Page

  partial(:header, Shared::Header)

  # Elements, etc.
  
  end
end
```
  
# Flows
  
**Flows** are user actions that span multiple _pages_, _apps_ or _sites_. They are therefore not
tied to any particular site or app. They simply become part of the **Huzzah::DSL**. 

To define a flow you create a ruby file in your _huzzah/flows_ directory. A method with the 
same name as the file (without the .rb extension) will be added to the **Huzzah::DSL** module. 
That method will return an instance of the _flow_ class.

Example: _admin.rb_

```ruby
class Admin < Huzzah::Flow

  def delete_user(user)
    # Code to perform the delete
  end
  
end
```
  
You can then call the your flows like this:
   
```ruby
admin.delete_user 'johndoe'   
```  
 
NOTE: You cannot use the same name for a Flow and an App. The framework will
throw an Huzzah::InvalidFlowNameError. 
  
  
# User Roles
A user role represents a single browser session. The browser is tied to a role, not to an particular site. The
relationship between the browser instance and the site being visited is determined by your test code. This allows you to have multiple users on any site or the ability to seamlessly transition users from one site to another.

You define your user roles after you configure your Huzzah environment:
```ruby
# Define a single user role
Huzzah.add_role :buyer

# Define multiple user roles
Huzzah.add_roles :buyer, :seller, :admin
```

NOTE: A browser will not be launched until you perform an action with the user.

Optionally, you can define your user roles in YAML files that contain information
about the roles:

```ruby
buyer.yml

---
qa:
  :username: 'johndoe'
  :password: 'password'
  :language: 'English'
  :name: 'John Doe'
prod:
  :username: 'johndoe'
  :password: '276dphr'
  :language: 'English'
  :name: 'John Doe'
```

You can store any config information about your user that you wish. The framework
will define a method (based on the filename) for the role. The keys of
the YAML file will be exposed as methods through an OpenStruct object.

```ruby
# Given the above YAML file for buyer, you can reference the data this way:
> buyer.username
=> 'johndoe'
> buyer.name
=> 'John Doe'
```

NOTE: If you define your roles through YAML file, do not call _Huzzah.add_role_
or _Huzzah.add_roles_.

# Factories & Models

Huzzah was designed to be used in conjunction with FactoryGirl and ActiveRecord for
managing test data and otherwise interacting with databases. For more information
on how to use this tools visit:

FactoryGirl
http://www.rubydoc.info/gems/factory_girl/file/GETTING_STARTED.md

ActiveRecord
http://guides.rubyonrails.org/active_record_basics.html

Huzzah will automatically require any files within the optional _factories_ & _models_ directories.

# The DSL
```ruby
# Switch user roles. Optionally, navigate to a site.
as :user

as :user, visit: 'google' # Calls 'visit' method
as :user, 'google'        # Calls 'visit' method

# Launch a browser to the env specified in the config for the specified site. 
visit :google 

# Load a site config without launching a browser.
load_config :google

# Return an OpenStruct of the site config yaml.
site_config

# Close all browsers for all defined roles
close_all_browsers

# Give focus to a popup window for the current user.
switch_to_window 'Contact Us'
switch_to_window title: 'Contact Us'
switch_to_window url: 'contact_us'
switch_to_window title: 'Contact Us', 60 # With timeout, defaults to 30 seconds.

# Give focus to the main browser for the current user.
switch_to_main_browser 

# Wait for Ajax to finish. Currently only works with jQuery.
wait_for_ajax
```

In addition, the framework dynamically adds methods to the DSL for all _apps (pages & partials)_ 
and _flows_.

The methods defined for _pages_ and _partials_ also accept blocks of code:
```ruby
# App example: Without Block
google(:home_page).set_search_terms 'Cucumber'
google(:home_page).search


# App example: With Block
google(:home_page) do |page|
  page.set_search_terms 'Cucumber'
  page.search
end   
```
The block functionality is most useful when you are performing multiple actions
on the page, but you may want to consider just creating a method in the page class
if the series of actions can be reused.

In addition, the DSL also wraps many of the methods in the Watir::Browser class,
allowing you to call those methods directly:
```ruby
driver
close
clear_cookies
execute_script(script, *args)
goto(url)
page_html
page_title
page_text
page_url
ready_state
send_keys(*args)
refresh
wait_until(*args, &block) 
wait_while(*args, &block)
window(*args, &block)
windows(*args)
```
# Running Tests Remotely
By default, Huzzah is configured to run locally on your machine using the type of
browser you set when you call:

```ruby
Huzzah.configure do |config|
  config.path = "<path to your 'huzzah' directory>"
  config.browser_type = :firefox
  config.environment = 'dev'
end
```

If you want to run your tests remotely on a Selenium Grid, you will need to do
some additional configuration. The example below shows how to run remotely using Chrome.


```ruby
Huzzah.config.grid_url = 'http://my.gridhub.server:9000/wd/hub'
Huzzah.config.remote = true
Huzzah.config.chrome(:switches => ["%w[--ignore-certificate-errors]"],
                     :version => '31', :platform => 'windows')
```

You can also run on Firefox or Internet Explorer by changing the method you call.

```ruby
Huzzah.config.internet_explorer(:version => '9', :platform => 'windows')

# This example passes a custom firefox profile (it is optional).
Huzzah.config.firefox(:firefox_profile => profile, :version => '24',
                      :platform => 'linux')
```
## Authors
* Lance Howard https://github.com/lkhoward
* Kevin Smith https://github.com/ksmithbaylor
