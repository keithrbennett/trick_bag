# Adapted from Test Unit test at https://github.com/neilparikh/ruby-linked-list.

require_relative '../../spec_helper'
require 'trick_bag/collections/linked_list'

module TrickBag
module Collections

describe LinkedList do

  specify 'to_a should return an array equal to the array with which it was initialized' do
    array = [1, 3, 5]
    expect(LinkedList.new(*array).to_a).to eq(array)
  end

  it 'should push correctly' do
    list = LinkedList.new(1)
    list.push(2)
    expect(list.to_a).to eq([1, 2])
  end

  it 'should pop from a list of multiple elements correctly' do
    list = LinkedList.new(1, 2, 3)
    expect(list.pop).to eq(3)
    expect(list.to_a).to eq([1, 2])
  end

  it 'should pop from a list of 1 element correctly' do
    list = LinkedList.new(1)
    expect(list.pop).to eq(1)
    expect(list.to_a).to eq([])
  end

  it 'should raise an error when popping from an empty list' do
    list = LinkedList.new
    expect(list.length).to eq(0)
    expect(->{ list.pop }).to raise_error(RuntimeError)
  end

  it 'should unshift correctly' do
    list = LinkedList.new(1)
    list.unshift(0)
    expect(list.to_a).to eq([0,1])
  end

  it 'should shift correctly from a list containing multiple elements' do
    list = LinkedList.new(1, 3, 4)
    expect(list.shift).to eq(1)
    expect(list.to_a).to eq([3, 4])
  end

  it 'should shift correctly from a list containing 1 element' do
    list = LinkedList.new(1)
    expect(list.shift).to eq(1)
    expect(list.to_a).to eq([])
  end

  it 'should raise an error when shifting from an empty list' do
    list = LinkedList.new
    expect(->{ list.shift }).to raise_error(RuntimeError)
  end
end
end
end
