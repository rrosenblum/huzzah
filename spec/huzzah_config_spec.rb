require 'spec_helper'

describe Huzzah, 'Config' do

  it 'accepts a configuration block' do
    configuration = Huzzah::Config.new do |config|
      config.path = "#{$PROJECT_ROOT}/examples/google"
      config.browser_type = :firefox
      config.environment = 'prod'
    end
    expect(configuration.environment).to eql 'prod'
  end

  it 'returns custom #inspect data' do
    configuration = Huzzah::Config.new do |config|
      config.path = "#{$PROJECT_ROOT}/examples/google"
      config.browser_type = :firefox
      config.environment = 'prod'
    end
    expect(configuration.inspect[:browser_type]).to eql :firefox
  end

  it 'sets Chrome capabilities for remote execution' do
    configuration = Huzzah::Config.new do |config|
      config.path = "#{$PROJECT_ROOT}/examples/google"
      config.environment = 'prod'
    end
    capabilities = { :version => '31', :platform => 'linux' }
    configuration.chrome capabilities
    expect(configuration.capabilities).to be_a_kind_of Selenium::WebDriver::Remote::Capabilities
    expect(configuration.capabilities[:browser_name]).to eql 'chrome'
    expect(configuration.capabilities[:version]).to eql '31'
    expect(configuration.capabilities[:platform]).to eql 'linux'
    expect(configuration.remote).to be true
  end

  it 'sets Firefox capabilities for remote execution' do
    configuration = Huzzah::Config.new do |config|
      config.path = "#{$PROJECT_ROOT}/examples/google"
      config.environment = 'prod'
    end
    capabilities = { :version => '37', :platform => 'linux' }
    configuration.firefox capabilities
    expect(configuration.capabilities).to be_a_kind_of Selenium::WebDriver::Remote::Capabilities
    expect(configuration.capabilities[:browser_name]).to eql 'firefox'
    expect(configuration.capabilities[:version]).to eql '37'
    expect(configuration.capabilities[:platform]).to eql 'linux'
    expect(configuration.remote).to be true
  end

  it 'sets Internet Explorer capabilities for remote execution' do
    configuration = Huzzah::Config.new do |config|
      config.path = "#{$PROJECT_ROOT}/examples/google"
      config.environment = 'prod'
    end
    capabilities = { :version => '10', :platform => 'Windows' }
    configuration.internet_explorer capabilities
    expect(configuration.capabilities).to be_a_kind_of Selenium::WebDriver::Remote::Capabilities
    expect(configuration.capabilities[:browser_name]).to eql 'internet explorer'
    expect(configuration.capabilities[:version]).to eql '10'
    expect(configuration.capabilities[:platform]).to eql 'Windows'
    expect(configuration.remote).to be true
  end

  it 'returns the grid configuration' do
    configuration = Huzzah::Config.new do |config|
      config.path = "#{$PROJECT_ROOT}/examples/google"
      config.grid_url = 'http://my_selenium_grid:9000/wd/hub'
      config.environment = 'prod'
    end
    capabilities = { :version => '10', :platform => 'Windows' }
    configuration.firefox capabilities
    expect(configuration.grid[:url]).to eql 'http://my_selenium_grid:9000/wd/hub'
    expect(configuration.grid[:desired_capabilities][:platform]).to  eql 'Windows'
  end

end