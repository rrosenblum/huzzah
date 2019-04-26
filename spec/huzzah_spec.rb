require 'support/spec_helper'

describe Huzzah do

  before(:each) do
    Huzzah.configure do |config|
      config.path = "#{$PROJECT_ROOT}/spec/examples"
      config.environment = 'prod'
      config.default_driver = :firefox_headless
    end
  end

  it 'sets the configuration' do
    expect(Huzzah.environment).to eql('prod')
  end

  it 'allows defining a custom browser/driver' do
    Huzzah.define_driver(:chrome) do
      Watir::Browser.new(:chrome)
    end
    expect(Huzzah.drivers.keys).to include('chrome')
  end

  it 'allows loadings a site config YAML' do
    expect(Huzzah.site_config(:bing)[:title]).to eql('Bing')
  end

end
