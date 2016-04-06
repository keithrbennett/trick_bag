module TrickBag
module Validations

  module_function

  class ObjectValidationError < RuntimeError;  end


  # Returns an array containing each symbol in vars for which the
  # corresponding instance variable  in the specified object is nil.
  def nil_instance_vars(object, vars)
    vars = Array(vars)
    vars.select { |var| object.instance_variable_get(var).nil? }
  end

  # For each symbol in vars, checks to see that the corresponding instance
  # variable in the specified object is not nil.
  # If any are nil, raises an error listing the nils.
  def raise_on_nil_instance_vars(object, vars)
    nil_vars = nil_instance_vars(object, vars)
    unless nil_vars.empty?
      raise ObjectValidationError.new("The following instance variables were nil: #{nil_vars.join(', ')}.")
    end
  end
end
end
