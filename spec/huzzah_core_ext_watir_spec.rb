require 'spec_helper'

describe 'Core Ext. Watir' do

  include Huzzah::DSL

  before(:each) do
    configure_test_site
  end

  after(:each) do
    close_all_browsers
  end

  it 'returns the selected option of a Select' do
    as :user1, visit: 'test_site'
    expect(test_site(:home).role_list.selected_option).to eql 'User'
  end

  it 'returns all Select options text' do
    as :user1, visit: 'test_site'
    expected_options = ['User', 'Employee', 'Admin']
    expect(test_site(:home).role_list.available_options).to eql expected_options
  end

end