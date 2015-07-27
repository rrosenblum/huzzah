require 'spec_helper'

describe Huzzah::DSL::Framework do

  include Huzzah::DSL

  before(:each) do
    configure_test_site
  end

  after(:each) do
    close_all_browsers
  end

  it 'navigates to a site (single-line style)' do
    as :user1, visit: 'test_site'
    expect(page_title).to include 'Home'
  end

  it 'navigates to a site (mutil-line style)' do
    as :user1
    visit 'test_site'
    expect(page_title).to include 'Home'
  end

  it 'switches use roles' do
    as :user1
    as :user2
    expect(active_role).to eql :user2
  end

  it 'switches the current user role and optionally visits a site' do
    as :user2, on: 'test_site'
    expect(page_title).to include 'Home'
  end

  it 'raises error if user role is not defined' do
    expect { as :buyer }.to raise_error Huzzah::UndefinedRoleError,
                                        'buyer'
  end

  it 'load a site config' do
    load_config :test_site
    expect(site_config.title).to eql 'Huzzah!'
  end

  it 'allows a block to access page elements without argument' do
    as :user1, on: 'test_site'
    name = user1.full_name
    test_site(:home) do
      set_full_name name
    end
    expect(test_site(:home).full_name.value).to eql user1.full_name
  end

end