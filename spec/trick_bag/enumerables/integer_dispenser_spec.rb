require_relative '../../spec_helper'
require 'trick_bag/enumerables/integer_dispenser'

module TrickBag
module Enumerables

describe IntegerDispenser do

  it 'should initialize with a first value' do
    expect(->() { IntegerDispenser.new(1001) }).not_to raise_error
  end

  it 'should respond to #next with the first_value param the first time next is called' do
    expect(IntegerDispenser.new(1001).next).to eq(1001)
  end

  it 'should raise an error if min > max' do
    expect(->() { IntegerDispenser.new(1500, 2000, 1500) }).to raise_error
  end

  it 'should raise an error if first value is not between min and max' do
    expect(->() { IntegerDispenser.new(1001, 2000, 1500) }).to raise_error
  end

  it 'should return 1002 on the second call to next() when 1001 is the initial value' do
    dispenser =  IntegerDispenser.new(1001, 1001, 1500)
    dispenser.next
    expect(dispenser.next).to eq(1002)
  end

  it 'should roll over to min_value after max_value is reached' do
    dispenser =  IntegerDispenser.new(1500, 1400, 1500)
    dispenser.next
    expect(dispenser.next).to eq(1400)
  end

end
end
end
