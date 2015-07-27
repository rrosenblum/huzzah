require 'spec_helper'

describe Huzzah, 'FactoryGirl Support' do

  before(:each) do
    configure_test_site
  end

  it 'autoloads defined factories & models' do
    expect(FactoryGirl.build(:inventory_item)).to be_kind_of Inventory
  end

end