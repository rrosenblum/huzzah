require 'spec_helper'

describe Huzzah::Site do

  before(:each) do
    @data = "#{$PROJECT_ROOT}/examples/google/sites/google.yml"
    @site = Huzzah::Site.new 'google', @data, 'prod'
  end

  it 'defines the site name' do
    expect(@site.name).to eql 'google'
  end

  it 'defines the site url' do
    expect(@site.url).to eql 'http://www.google.com'
  end

  it 'defines data about the site' do
    expect(@site.data).to respond_to :url
  end

  it 'handles calls to site data through method_missing' do
    expect(@site.title).to eql 'Google'
  end

  it 'raises error for undefined methods' do
    expect { @site.foo }.to raise_error Huzzah::NoMethodError,
                                        "Method 'foo' undefined for google site."
  end

end