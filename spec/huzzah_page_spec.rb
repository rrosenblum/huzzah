require 'spec_helper'

describe Huzzah, 'Page' do

  include Huzzah::DSL

  before(:each) do
    Huzzah.reset!
    Huzzah.configure do |config|
      config.path = "#{$PROJECT_ROOT}/sandbox/huzzah"
      config.browser_type = :firefox
      config.environment = 'dev'
    end
    Huzzah.add_role :user
  end

  after(:each) do
    close_all_browsers
  end

  it "should allow adding 'let' methods" do
    Testapp::HomePage.let(:foo) { div(id: 'foo') }
    expect(Testapp::HomePage.instance_methods).to include :foo
  end

  it "should not allow duplicate 'let' methods" do
    expect { Testapp::HomePage.let(:main) { div(id: 'main') }
      }.to raise_error Huzzah::DuplicateElementMethodError, 'main'
  end

  it 'should initialize browser' do
    as :user, on: 'testsite'
    browser = testapp(:home_page).browser
    expect(browser).to be_kind_of Watir::Browser
  end

  it "should wrap watir-webdriver 'browser' methods" do
    as :user, on: 'dreamcars'
    expect(dreamcars(:home_page).title).to eql 'Home | MDC'
  end

  it "should wrap watir-webdriver 'container' methods" do
    as :user, on: 'dreamcars'
    expect(dreamcars(:home_page).form(id: 'home_search').text).to include 'Drive Your Dream Car'
  end

  it 'should check for text on the page' do
    as :user, on: 'dreamcars'
    expect(dreamcars(:home_page).has_text? 'Manheim Dream Cars').to be_truthy
  end

  it 'should raise error for unknown methods' do
    as :user, on: 'dreamcars'
    expect { dreamcars(:home_page).undefined_method
      }.to raise_error Huzzah::NoMethodError, 'undefined_method undefined in Dreamcars::HomePage'
  end

  it "should allow adding 'partial' pages" do
    as :user, on: 'dreamcars'
    expect(dreamcars(:home_page).header).to be_kind_of Dreamcars::Header
    expect(dreamcars(:home_page).header.methods).to include :view_home
  end

end