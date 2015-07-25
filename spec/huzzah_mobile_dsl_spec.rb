require 'spec_helper'

describe 'Huzzah Appium' do

  include Huzzah::DSL::Mobile

  before(:each) do
    Huzzah.reset!
    Huzzah.configure do |config|
      config.path = "#{$PROJECT_ROOT}/sandbox/huzzah"
      config.browser_type = :firefox
      config.environment = 'dev'
    end
    caps   = { caps:       { platformName: 'Android',
                             deviceName: 'TC70',
                             #app: Dir.pwd+'/VMS.apk',
                             appPackage: 'com.manheim.icfw',
                             appActivity: 'com.antennasoftware.hybridcontainer.MainActivity',
                             newCommandTimeout: 600,
                             autoWebview: true,
                             #appActivity: '.Settings',
                             #appPackage: 'com.android.settings'
    },
               appium_lib: { sauce_username: nil,
                             sauce_access_key: nil } }
    Huzzah.config.android caps
    Huzzah.add_role :mobile_user
    Huzzah.current_role.session.driver_type = :appium
    Huzzah.current_role.session.start
  end

  it 'should promote Appium methods' do
    pending
  end

end