require_relative 'support/spec_helper'

RSpec.describe Huzzah::Cucumber::DSL do

  include Huzzah::Cucumber::DSL

  before(:each) do
    Huzzah.configure do |config|
      config.path = "#{$PROJECT_ROOT}/spec/examples"
      config.environment = 'prod'
      config.default_driver = :firefox_headless
    end
  end

  after(:each) do
    @role1.browser.close if @role1 && @role1.browser
    @role2.browser.close if @role2 && @role2.browser
  end

  it 'dynamically switches roles' do
    @role1 = Huzzah::Role.new
    @role2 = Huzzah::Role.new(:standard_user)
    expect(as('role2').role_data[:password]).to eql('p@$$W0rD')
  end

  it 'fails when switching to an undefined role' do
    @role1 = Huzzah::Role.new
    @role2 = Huzzah::Role.new(:standard_user)
    expect { as 'role3' }.to raise_error(Huzzah::RoleNotDefinedError)
  end

  it 'fails when the specified role is not a Huzzah::Role object' do
    @role1 = Huzzah::Role.new
    @role2 = Huzzah::Role.new(:standard_user)
    @not_a_role = []
    expect { as 'not_a_role' }.to raise_error(Huzzah::NotARoleError)
  end

  it 'closes the browser for each instantiated role' do
    @role1 = Huzzah::Role.new
    @role2 = Huzzah::Role.new(:standard_user)
    close_browsers
    expect(@role1.browser).not_to be_exists
    expect(@role2.browser).not_to be_exists
  end

  it 'handles a block of code' do
    @role1 = Huzzah::Role.new
    as(:role1) do
      bing.visit
      bing.home_page.search_box.set('foo')
    end
    expect(@role1.bing.home_page.search_box.value).to eql('foo')
  end

end
