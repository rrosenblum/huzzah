require 'support/spec_helper'
require_relative 'examples/partials/google_search_form'
require_relative 'examples/pages/google/home'

describe Huzzah::Page do

  before(:each) do
    Huzzah.configure do |config|
      config.path = "#{$PROJECT_ROOT}/spec/examples"
      config.environment = 'prod'
      config.default_driver = :firefox
    end
  end

  after(:each) do
    @role.browser.close if @role
  end

  it "allows adding 'locator' statements" do
    Google::Home.locator(:foo) { div(id: 'foo') }
    expect(Google::Home.instance_methods).to include :foo
  end

  it "does not allow duplicate 'locator' statements" do
    expect { Google::Home.locator(:search) { div(id: 'search') }
      }.to raise_error Huzzah::DuplicateLocatorMethodError, 'search'
  end

  it "does not allow 'locator' method name from the Watir::Container module" do
    expect { Google::Home.locator(:table) { div(id: 'main') }
    }.to raise_error Huzzah::RestrictedMethodNameError
  end

  it 'accepts the browser upon initialization' do
    @role = Huzzah::Role.new
    browser = @role.google.home.browser
    expect(browser).to be_kind_of Watir::Browser
  end

  it "wraps watir-webdriver 'browser' methods" do
    @role = Huzzah::Role.new
    @role.google.visit
    expect(@role.google.home.title).to eql 'Google'
  end

  it "wraps watir-webdriver 'container' methods" do
    @role = Huzzah::Role.new
    @role.google.visit
    expect(@role.google.home.button(name: 'btnK').value).to eql 'Google Search'
  end

  it 'raises error for unknown methods' do
    @role = Huzzah::Role.new
    @role.google.visit
    expect { @role.google.home.undefined_method
      }.to raise_error Huzzah::NoMethodError,
                       "Method 'undefined_method' undefined in Google::Home"
  end

  it "allows adding 'partial' pages" do
    @role = Huzzah::Role.new
    @role.google.visit
    expect(@role.google.home.search_form).to be_kind_of GoogleSearchForm
    expect(@role.google.home.search_form.methods).to include :keywords
  end

end