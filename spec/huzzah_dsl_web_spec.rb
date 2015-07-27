require 'spec_helper'

describe Huzzah::DSL::Web do

  include Huzzah::DSL

  before(:each) do
    configure_test_site
  end

  after(:each) do
    close_all_browsers
  end

  it 'handles switching browser window by partial Title' do
    as :user2, on: 'test_site'
    test_site(:home).launch_popup
    switch_to_window title: 'Popup'
    expect(page_title).to include 'Popup'
  end

  it 'handles switching browser window by partial URL' do
    as :user2, on: 'test_site'
    test_site(:home).launch_popup
    switch_to_window url: 'popup.html'
    expect(page_title).to include 'Popup'
  end

  it 'switching browser windows uses partial Title by default' do
    as :user2, on: 'test_site'
    test_site(:home).launch_popup
    switch_to_window 'Popup'
    expect(page_title).to include 'Popup'
  end

  it 'handles switching back to main window' do
    as :user2, on: 'test_site'
    test_site(:home).launch_popup
    switch_to_window 'Popup'
    switch_to_main_browser
    expect(page_title).to include 'Home'
  end

  it 'handles clearing browser cookies' do

  end

  it 'allows navigation to a specific url' do
    as :user1, on: 'test_site'
    goto 'http://www.bing.com'
    expect(page_url).to include 'bing.com'
  end

  it 'returns the page html' do
    as :user1, on: 'test_site'
    expect(page_html).to include '<body>'
  end

  it 'returns the browser ready state' do
    as :user1, on: 'test_site'
    expect(ready_state).to eql 'complete'
  end

  it 'handles sending keys to the browser' do
    as :user1, on: 'test_site'
    expect(send_keys :enter).to eql ''
  end

  it 'returns the page text' do
    as :user1, on: 'test_site'
    expect(page_text).to include 'Huzzah!'
  end

  it 'returns the page title' do
    as :user1, on: 'test_site'
    expect(page_title).to include 'Home'
  end

  it 'returns the page url' do
    as :user1, on: 'test_site'
    expect(page_url).to include 'index.html'
  end

  it 'refreshes the browser' do
    as :user1, on: 'test_site'
    expect(refresh).to be_kind_of Array
  end

  it 'waits until a condition is met' do
    as :user1, on: 'test_site'
    expect(wait_until { page_text.include? 'Huzzah!'} ).to be_truthy
  end

  it 'waits while a condition is true' do
    as :user1, on: 'test_site'
    expect(wait_while { page_text.include? 'Watir'} ).to be_nil
  end

  it 'selects a specific browser window' do
    as :user1, on: 'test_site'
    test_site(:home).launch_popup
    window(title: 'Huzzah Test Site - Popup').use
    expect(page_text).to include 'Window Switching Test Page'
  end

end