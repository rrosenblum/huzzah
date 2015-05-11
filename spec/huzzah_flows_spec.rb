require 'spec_helper'

describe Huzzah, 'Flows' do

  include Huzzah::DSL

  before(:each) do
    Huzzah.reset!
    Huzzah.configure do |config|
      config.path = "#{$PROJECT_ROOT}/sandbox/huzzah"
      config.browser_type = :firefox
      config.environment = 'dev'
    end
  end

  after(:each) do
    close_all_browsers
  end

  it "defines a DSL method for each flow" do
    expect(Huzzah::DSL.instance_methods).to include :test_flow
  end

  it 'should have access to the DSL' do
    expect(test_flow.methods).to include :dreamcars
  end

  it 'should have access to other flows' do
    expect(test_flow.methods).to include :test_flow2
  end

  it 'should not have colliding method definitions' do
    expect(test_flow.foo).to eql 'test_flow'
    expect(test_flow2.foo).to eql 'test_flow2'
  end

end