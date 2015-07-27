require 'spec_helper'

describe Huzzah::Flow do

  class SampleFlow < Huzzah::Flow

    def foo
      'foo'
    end

  end

  it 'has access to Huzzah::DSL methods' do
    flow = SampleFlow.new
    expect(flow.methods).to include :wait_while
  end

  it 'responds to custom methods' do
    flow = SampleFlow.new
    expect(flow.foo).to eql 'foo'
  end

end