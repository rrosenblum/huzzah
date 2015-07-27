require 'spec_helper'

describe Huzzah, 'Page' do

  include Huzzah::DSL

  before(:each) do
    configure_google
  end

  after(:each) do
    close_all_browsers
  end

  it "allows adding 'let' statements" do
    Google::Home.let(:foo) { div(id: 'foo') }
    expect(Google::Home.instance_methods).to include :foo
  end

  it "does not allow duplicate 'let' statements" do
    expect { Google::Results.let(:results) { div(id: 'search') }
      }.to raise_error Huzzah::DuplicateElementMethodError, 'results'
  end

  it "does not allow 'let' method name from the Watir::Container module" do
    expect { Google::Home.let(:table) { div(id: 'main') }
    }.to raise_error Huzzah::RestrictedMethodNameError,
                     "You cannot use method names like 'table' from the Watir::Container module in 'let' statements"
  end

  it 'accepts the browser upon initialization' do
    as :user, on: 'google'
    browser = google(:home).browser
    expect(browser).to be_kind_of Watir::Browser
  end

  it "wraps watir-webdriver 'browser' methods" do
    as :user, on: 'google'
    expect(google(:home).title).to eql 'Google'
  end

  it "wraps watir-webdriver 'container' methods" do
    as :user, on: 'google'
    expect(google(:home).button(name: 'btnK').value).to eql 'Google Search'
  end

  it 'checks for text on the page' do
    as :user, on: 'google'
    expect(google(:home).has_text? 'Gmail').to be_truthy
  end

  it 'raises error for unknown methods' do
    as :user, on: 'google'
    expect { google(:home).undefined_method
      }.to raise_error Huzzah::NoMethodError,
                       "Method 'undefined_method' undefined in Google::Home"
  end

  it "allows adding 'partial' pages" do
    as :user, on: 'google'
    expect(google(:home).search_form).to be_kind_of Google::SearchForm
    expect(google(:home).search_form.methods).to include :keywords
  end

end