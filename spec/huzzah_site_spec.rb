require_relative 'support/spec_helper'

describe Huzzah::Site do

  before(:each) do
    Huzzah.configure do |config|
      config.path = "#{$PROJECT_ROOT}/spec/examples"
      config.environment = 'prod'
      config.default_driver = :firefox
    end
  end

  after(:each) do
    @role.browser.close if @role.browser
  end

  it "knows it's name" do
    @role = Huzzah::Role.new
    expect(@role.bing.site_name).to eql(:bing)
  end

  it 'automatically loads the config' do
    @role = Huzzah::Role.new
    expect(@role.google.config[:title]).to eql('Google')
  end

  it 'automatically assigns the role data' do
    @role = Huzzah::Role.new(:standard_user)
    expect(@role.bing.role_data[:full_name]).to eql('George Washington')
  end

  it 'knows the browser' do
    @role = Huzzah::Role.new
    expect(@role.google.browser).to be_a(Watir::Browser)
  end

  it 'automatically loads the pages for the site' do
    @role = Huzzah::Role.new
    expect(@role.google.home).to be_a(Huzzah::Page)
  end

  it 'allows dynamically calling a page-object (Symbol)' do
    @role = Huzzah::Role.new
    @role.google.visit
    expect(@role.google.on(:home)).to be_a(Huzzah::Page)
  end

  it 'allows dynamically calling a page-object (String)' do
    @role = Huzzah::Role.new
    @role.google.visit
    expect(@role.google.on('home')).to be_a(Huzzah::Page)
  end

  it 'fails when dynamically calling a page-object with the wrong type' do
    @role = Huzzah::Role.new
    @role.google.visit
    expect { @role.google.on(1) }.to raise_error(TypeError)
  end

  it 'handles a block of code' do
    @role = Huzzah::Role.new
    @role.bing.visit
    @role.bing { home_page.search_box.set('foo') }
    expect(@role.bing.home_page.search_box.value).to eql('foo')
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
