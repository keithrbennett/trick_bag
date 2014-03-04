require_relative '../../spec_helper.rb'

require 'trick_bag/validations/object_validations'

module TrickBag
module Validations
  describe ObjectValidations do

    include ObjectValidations

      specify 'a missing instance variable should raise an error' do
        vars = [:@this_name_could_not_possibly_be_defined_as_a_real_variable]
        expect(-> { raise_on_nil_instance_vars(self, vars) }).to raise_error
      end

      specify 'an existing instance variable should NOT raise an error' do
        vars = [:@foo]
        -> { class AbCdEfG; def initialize; @foo = 'hi'; end; end }.()
        expect(-> { raise_on_nil_instance_vars(AbCdEfG.new, vars) }).not_to raise_error
      end
    end
end
end
