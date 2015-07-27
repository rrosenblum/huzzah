require 'spec_helper'

describe Huzzah, 'Role' do

  before(:each) do
    @role = Huzzah::Role.new 'user', nil, nil
  end

  it 'sets the role name' do
    expect(@role.name).to eql 'user'
  end

  it 'handles no role data' do
    expect(@role.data).to be_nil
  end

  it 'defaults user_type to :web' do
    expect(@role.user_type).to eql :web
  end

  it 'handles role data from a yml file' do
    data = "#{$PROJECT_ROOT}/examples/google/roles/user.yml"
    @role = Huzzah::Role.new 'foo', data, 'prod'
    expect(@role.data).to be_kind_of OpenStruct
    expect(@role.data.username).to eql 'foo'
    expect(@role.data.password).to eql 'bar'
  end

  it 'uses method_missing to directly call methods within the role data' do
    data = "#{$PROJECT_ROOT}/examples/google/roles/user.yml"
    @role = Huzzah::Role.new 'user', data, 'prod'
    expect(@role.username).to eql 'foo'
  end

  it 'raises error if method called is not is role data' do
    expect { @role.foo }.to raise_error Huzzah::NoMethodError,
                                        "Method 'foo' undefined for Huzzah::Role"
  end

  it 'allows a custom user_type' do
    data = "#{$PROJECT_ROOT}/examples/test_site/roles/user3.yml"
    @role = Huzzah::Role.new 'user3', data, 'local'
    expect(@role.user_type).to eql :mobile
  end

end