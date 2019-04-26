require 'support/spec_helper'

describe 'Partials' do

  before(:each) do
    Huzzah.configure do |config|
      config.path = "#{$PROJECT_ROOT}/spec/examples"
      config.environment = 'prod'
      config.default_driver = :firefox_headless
    end
  end

  after(:each) do
    @role.browser.close if @role && @role.browser
  end

  it 'allows direct access to a partial' do
    @role = Huzzah::Role.new
    expect(@role.google.search_form).to be_a(Huzzah::Page)
  end

  it 'allows access through a page' do
    @role = Huzzah::Role.new
    expect(@role.google.home.search_form).to be_a(Huzzah::Page)
  end

  it 'allows access to methods in partials' do
    @role = Huzzah::Role.new
    expect(@role.google.home.search_form).to respond_to(:keywords)
  end

  it 'handles a block of code' do
    @role = Huzzah::Role.new
    @role.google.visit
    @role.google.home.search_form do
      keywords.set('foo')
    end
    expect(@role.google.home.search_form.keywords.value).to eql('foo')
  end
end
