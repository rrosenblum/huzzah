require 'support/spec_helper'

describe Huzzah::Page do

  before(:each) do
    Huzzah.configure do |config|
      config.path = "#{$PROJECT_ROOT}/spec/examples"
      config.environment = 'prod'
      config.default_driver = :firefox
    end
  end

  after(:each) do
    if @role
      @role.browser.close if @role.browser
    end
  end

  it 'returns a instance of a page' do
    @role = Huzzah::Role.new
    expect(@role.google.home).to be_a Huzzah::Page
  end

  it 'fails for undefined pages' do
    @role = Huzzah::Role.new
    expect { @role.google.foo }.to raise_error NoMethodError
  end

  it "allows adding 'locator' statements" do
    Google::Home.locator(:foo) { div(id: 'foo') }
    expect(Google::Home.instance_methods).to include :foo
  end

  it "does not allow duplicate 'locator' statements" do
    @role = Huzzah::Role.new
    expect { Google::Home.locator(:search) { div(id: 'search') }
      }.to raise_error Huzzah::DuplicateLocatorMethodError, 'search'
  end

  it 'calls a locator by name' do
    @role = Huzzah::Role.new
    expect(@role.bing.home_page.search_box).to exist
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
    expect(@role.google.home.title).to eql 'Google'
  end

  it "wraps watir-webdriver 'container' methods" do
    @role = Huzzah::Role.new
    expect(@role.google.home.button(name: 'btnK').value).to eql 'Google Search'
  end

  it 'allows access to methods in partials' do
    @role = Huzzah::Role.new
    binding.pry
    expect(@role.google.home.search_form).to respond_to(:keywords)
  end

end