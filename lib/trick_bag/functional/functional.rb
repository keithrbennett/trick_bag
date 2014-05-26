module TrickBag

  module_function


  # Returns whether or not none of the condition lambdas return true
  # when passed the specified object
  def none_with_object?(conditions, object)
    conditions.none? { |condition| condition.(object) }
  end


  # Returns whether or not all of the condition lambdas return true
  # when passed the specified object
  def all_with_object?(conditions, object)
    conditions.all? { |condition| condition.(object) }
  end


  # Returns whether or not any of the condition lambdas return true
  # when passed the specified object
  def any_with_object?(conditions, object)
    conditions.any? { |condition| condition.(object) }
  end
end
