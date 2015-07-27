require 'spec_helper'

describe Huzzah do

  include Huzzah::DSL

  before(:each) do
    configure_test_site
  end

  after(:each) do
    close_all_browsers
  end

  it 'returns the configuration' do
    expect(Huzzah.configuration[:path]).to include '/huzzah/spec/examples/test_site'
    expect(Huzzah.configuration[:browser_type]).to eql :firefox
    expect(Huzzah.configuration[:environment]).to eql 'local'
  end

  it 'loads site configs' do
    expect(Huzzah.sites.keys.sort).to eql [:test_site]
    expect(Huzzah.sites[:test_site].url).to include 'index.html'
  end

  it 'defines user roles manually' do
    Huzzah.add_role :buyer
    Huzzah.add_role 'seller'
    expect(Huzzah.roles[:buyer]).to be_kind_of Huzzah::Role
    expect(Huzzah.roles[:seller]).to be_kind_of Huzzah::Role
  end

  it 'defines a user roles from yml files' do
    expect(Huzzah.roles.keys).to include :user1
    expect(Huzzah.roles.keys).to include :user2
  end

  it 'defines multiple user roles' do
    Huzzah.add_roles :user, 'buyer', :seller, :admin
    expect(Huzzah.roles.keys).to include :admin
  end

  it 'raises error if user role is already defined' do
    expect { Huzzah.add_roles :buyer, :seller, :buyer
      }.to raise_error Huzzah::DuplicateMethodNameError,
                       "'buyer' is already defined!"
  end

  it 'knows the current user role' do
    expect(Huzzah.active_role.name).to eql :user3
  end

  it 'switches the current user role' do
    as :user2
    expect(Huzzah.active_role.name).to eql :user2
  end

  it 'load partials' do
    expect(Huzzah.pages).to have_key 'TestSite::Footer'
  end

  it 'load pages' do
    expect(Huzzah.pages).to have_key 'TestSite::Home'
  end

  it 'defines DSL methods to return pages' do
    expect(Huzzah::DSL.instance_methods).to include :test_site
  end


end