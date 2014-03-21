# Adapted from Test Unit test at https://github.com/neilparikh/ruby-linked-list.

require_relative '../../spec_helper'
require 'trick_bag/collections/linked_list'

module TrickBag
module Collections

describe LinkedList do

  let(:sample_array) { [1, 2, 3] }
  let(:sample_list) { LinkedList.new(*sample_array) }

  specify 'to_a should return an array equal to the array with which it was initialized' do
    expect(LinkedList.new(*sample_array).to_a).to eq(sample_array)
  end

  it 'should push correctly' do
    list = LinkedList.new(1)
    list.push(2)
    expect(list.to_a).to eq([1, 2])
  end

  it 'should pop from a list of multiple elements correctly' do
    expect(sample_list.pop).to eq(3)
    expect(sample_list.to_a).to eq([1, 2])
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
    expect(sample_list.shift).to eq(1)
    expect(sample_list.to_a).to eq([2, 3])
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

  specify 'to_ary should return an array identical to that returned by to_a' do
    a = sample_list.to_a
    ary = sample_list.to_ary
    expect(ary).to eq(a)
  end
end
end
end
