require 'factory_girl'

FactoryGirl.define do

  factory :inventory_item, class: Inventory do
    stock_num    '1234'
    description  'Foo'
    price        '$100.00'
  end

end