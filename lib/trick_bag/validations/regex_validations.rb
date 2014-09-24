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


  # Analyzes a list of strings and a list of regexes, gathering information
  # about which regexes match which strings.  The to_h method returns
  # a hash whose keys are the regexes and values are arrays of strings
  # in the string list that match the regex.  Note that if a string matches
  # multiple regexes, it will be added to the arrays of all the regexes it matched.
  class RegexStringListAnalyzer

    attr_reader :regex_strings_hash

    def initialize(regexes, strings)
      @regex_strings_hash = regexes.each_with_object({}) do |regex, match_hash|
        match_hash[regex] = []
      end
      strings.each do |string|
        regexes_matched = regexes.select { |regex| regex === string }
        regexes_matched.each do |regex_matched|
          regex_strings_hash[regex_matched] << string
        end
      end
    end


    # Returns a hash whose keys are the regexes, and the values are the
    # strings that matched the regex key.
    def to_h
      @regex_strings_hash
    end


    # Takes a match hash returned by the match_hash method above,
    # and returns the regexes for which no matches were found.
    def regexes_without_matches
      regex_strings_hash.keys.select { |key| regex_strings_hash[key].empty? }
    end


    # Takes a match hash returned by the match_hash method above,
    # and returns the regexes for which matches were found.
    def regexes_with_matches
      regex_strings_hash.keys.reject { |key| regex_strings_hash[key].empty? }
    end


    # Takes a match hash returned by the match_hash method above,
    # and returns string representations of the regexes
    # for which no matches were found.
    def regexes_without_matches_as_strings
      regexes_without_matches.map(&:inspect)
    end


    # Takes a match hash returned by the match_hash method above,
    # and returns string representations of the regexes
    # for which matches were found.
    def regexes_with_matches_as_strings
      regexes_with_matches.map(&:inspect)
    end
  end

end
end
