require 'spec_helper'
require_relative '../lib/core_ext/string'

describe 'Core Ext. String' do

  it 'converts complex strings to symbols' do
    expect('Complex String'.symbolize).to eql :complex_string
  end

  it 'makes unique strings' do
    expect('Foo'.to_unique_string).not_to eql 'Foo'
  end

  it 'converts a comma-delimited String to an array' do
    expect('One, Two, Three'.to_csv).to eql ['One', 'Two', 'Three']
  end

  it 'formats a String of numbers to dollars' do
    expect('100000'.to_currency).to eql '$100,000'
  end

  it 'returns the last (number of) characters of a String' do
    expect('12345'.last(2)).to eql '45'
  end

end