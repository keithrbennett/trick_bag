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


  # Returns a hash whose keys are the regexes and values are arrays of strings
  # in the passed list that match the regex.  Note that if a string matches
  # multiple regexes, it will be added to the arrays of all the regexes it matched.
  def match_hash(regexes, strings)
    regex_strings_hash = regexes.each_with_object({}) do |regex, match_hash|
      match_hash[regex] = []
    end
    strings.each do |string|
      regexes_matched = regexes.select { |regex| regex === string }
      regexes_matched.each do |regex_matched|
        regex_strings_hash[regex_matched] << string
      end
    end
    regex_strings_hash
  end


  # Takes a match hash returned by the match_hash method above,
  # and returns the regexes for which no matches were found.
  def regexes_without_matches(match_hash)
    match_hash.keys.select { |key| match_hash[key].empty? }
  end


  # Takes a match hash returned by the match_hash method above,
  # and returns the regexes for which matches were found.
  def regexes_with_matches(match_hash)
    match_hash.keys.reject { |key| match_hash[key].empty? }
  end

end
end
