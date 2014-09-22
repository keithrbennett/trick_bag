module TrickBag
module Validations

  module_function


  # @return whether or not the passed string matches *any* of the regexes in the passed array
  # @param regexes array of regexes to test against
  # @param string the string to test against the regexes
  def matches_any_regex?(regexes, string)
    regexes.any? { |regex| regex === string }
  end


  # @return whether or not the passed string matches *all* of the regexes in the passed array
  # @param regexes array of regexes to test against
  # @param string the string to test against the regexes
  def matches_all_regexes?(regexes, string)
    regexes.all? { |regex| regex === string }
  end


  # @return whether or not the passed string matches *none* of the regexes in the passed array
  # @param regexes array of regexes to test against
  # @param string the string to test against the regexes
  def matches_no_regexes?(regexes, string)
    regexes.none? { |regex| regex === string }
  end

end
end
