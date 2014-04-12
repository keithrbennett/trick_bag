require_relative '../../spec_helper'

require 'trick_bag/formatters/erb_renderer'

module TrickBag

describe ErbRenderer do

  specify 'it can be instantiated with a hash' do
    expect(TrickBag::ErbRenderer.new(color: 'blue').color).to eq('blue')
  end

  specify 'it can substitute a simple value' do
    expect(TrickBag::ErbRenderer.new(x: 3).render("[<%= x %>]")).to eq('[3]')
  end

  specify 'the template cannot see local variables' do
    x = 3
    expect(TrickBag::ErbRenderer.new.render("<%= x %>")).to be_empty
  end

  specify 'the template cannot see instance variables of other classes' do
    @x = 3
    expect(TrickBag::ErbRenderer.new.render("<%= @x %>")).to be_empty
  end

  specify 'it works when a value is added after instantiation' do
    renderer = ErbRenderer.new
    renderer.fruit = 'mango'
    expect(renderer.render("<%= fruit %>")).to eq('mango')
  end

end
end
