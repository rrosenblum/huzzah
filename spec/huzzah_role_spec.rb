require_relative 'support/spec_helper'

describe Huzzah::Role do

  before(:each) do
    Huzzah.configure do |config|
      config.path = "#{$PROJECT_ROOT}/spec/examples"
      config.environment = 'prod'
      config.default_driver = :firefox
    end
  end

  after(:each) do
    @role.browser.close if @role && @role.browser
  end

  it 'allows unspecified roles' do
    @role = Huzzah::Role.new
    expect(@role).to be_a(Huzzah::Role)
  end

  it 'allows dynamically defined roles with no role data' do
    @role = Huzzah::Role.new('super_user')
    expect(@role.role_data).to be_empty
  end

  it 'loads user data from a matching yaml file (String)' do
    @role = Huzzah::Role.new('standard_user')
    expect(@role.role_data[:username]).to eql('gwashington')
  end

  it 'loads user data from a matching yaml file (Symbol)' do
    @role = Huzzah::Role.new(:standard_user)
    expect(@role.role_data[:username]).to eql('gwashington')
  end

  it 'takes role data as a hash' do
    custom_data = { full_name: 'John Doe' }
    @role = Huzzah::Role.new(:my_role, custom_data)
    expect(@role.role_data[:full_name]).to eql('John Doe')
  end

  it 'takes role data as a hash without a role name provided' do
    custom_data = { full_name: 'John Doe' }
    @role = Huzzah::Role.new(custom_data)
    expect(@role.role_data[:full_name]).to eql('John Doe')
  end

  it 'merges role data when a hash and yaml file are provided' do
    custom_data = { full_name: 'John Doe' }
    @role = Huzzah::Role.new('standard_user', custom_data)
    expect(@role.role_data[:full_name]).to eql('John Doe')
  end

  it 'only accepts a Hash for custom role data' do
    custom_data = 'John Doe'
    expect { Huzzah::Role.new('standard_user', custom_data)
    }.to raise_error(ArgumentError)
  end

  it 'freezes the role data' do
    @role = Huzzah::Role.new('standard_user')
    expect(@role.role_data).to be_frozen
  end

  it 'initializes the browser to the default_driver' do
    @role = Huzzah::Role.new('standard_user').visit(:google)
    expect(@role.browser).to be_a(Watir::Browser)
  end

  it 'initializes the browser to a custom driver when specified' do
    Huzzah.define_driver(:custom_firefox) do
      Watir::Browser.new(:firefox)
    end
    @role = Huzzah::Role.new('custom_user').visit(:google)
    expect(@role.driver).to eql('custom_firefox')
  end

  it 'fails on undefined drivers' do
    Huzzah.default_driver = :foo_firefox
    expect { Huzzah::Role.new }.to raise_error(Huzzah::DriverNotDefinedError)
  end

  it 'passes the role data to the defined sites' do
    @role = Huzzah::Role.new
    expect(@role.google.role_data.object_id).to eql(@role.role_data.object_id)
  end

  it 'dynamically switches the site (Symbol)' do
    @role = Huzzah::Role.new
    expect(@role.on(:bing).config[:title]).to eql('Bing')
  end

  it 'dynamically switches the site (String)' do
    @role = Huzzah::Role.new
    expect(@role.on('bing').config[:title]).to eql('Bing')
  end

  it 'fails when dynamically calling a page-object with the wrong type' do
    @role = Huzzah::Role.new
    @role.google.visit
    expect { @role.on(1) }.to raise_error(TypeError)
  end


  context 'sites with yaml configuration files' do

    it "dynamically instantiates site" do
      @role = Huzzah::Role.new
      expect(@role.google).to be_a(Huzzah::Site)
    end

    it 'launches a browser' do
      @role = Huzzah::Role.new
      expect(@role.google.browser).to be_a(Watir::Browser)
    end

    it 'navigates the browser to the Huzzah.environment URL' do
      @role = Huzzah::Role.new
      @role.visit(:google)
      expect(@role.google.browser.title).to eql('Google')
    end

  end


  context 'sites without yaml configuration files' do

    it "dynamically instantiates site" do
      @role = Huzzah::Role.new
      expect(@role.wikipedia).to be_a(Huzzah::Site)
    end

    it 'does not load site data' do
      @role = Huzzah::Role.new
      expect(@role.wikipedia.config).to be_empty
    end

    it 'does not navigate the browser' do
      @role = Huzzah::Role.new
      expect(@role.wikipedia.browser.url).not_to include('wikipedia')
    end

    it 'uses the browser from first site visited' do
      @role = Huzzah::Role.new
      @role.visit(:google)
      expect(@role.wikipedia.browser).to be_a(Watir::Browser)
    end

  end

  context 'undefined sites' do

    it 'raise an error when the site namespace in undefined' do
      @role = Huzzah::Role.new
      expect { @role.yahoo }.to raise_error(NoMethodError)
    end

  end

end