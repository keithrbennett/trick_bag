module TrickBag
module Validations

  module_function

  # Used to succinctly (for the caller) check to see that a value provided by the caller
  # is included in the passed enumerable.  Raises an error if not, e.g.:
  #
  # raise_on_invalid_value('foo', [:bar, :baz], 'manufacturer')
  #
  # will raise an error with the following message:
  #
  # Invalid manufacturer 'foo'; must be one of: [:bar, :baz].
  #
  # If the passed value is included in the valid values, this method returns silently.
  #
  # @param value the value to check against the valid values
  # @param the valid values, of which the value should be one
  # @param label a string to include in the error message after "Invalid ", default to 'value'
  # @param output_with_inspect if true, the values' inspect method will be called for the
  #           error string; this will preserve the colon in symbols; if false, to_s will be used.
  def raise_on_invalid_value(value, valid_values, label = 'value', output_with_inspect = true)
    missing = ! valid_values.include?(value)

    if missing
      values_display_array = output_with_inspect ? valid_values.map(&:inspect) : valid_values.map(&:to_s)
      message = "Invalid #{label} '#{value}'; must be one of: [#{values_display_array.join(', ')}]."
      raise message
    end
  end


  # When a gem project has a .gemspec, this uses bundle exec to verify that requiring
  # that gem name does not result in an error. (An error would occur, for example,
  # if a gem required by the project gem is not specified as a dependency in
  # the .gemspec file.
  #
  # @return a hash containing the :exit_status (0 = success), output (stdout + stderr),
  # and the :process_status (Process::Status object).
  def test_gem_dependency_specs(gem_name)
    command = %Q{bundle exec ruby -e "require '#{gem_name}'"}

    output, process_status = Open3.capture2e(command)

    output.prepend(command + "\n\n")

    {
        exit_status: process_status.exitstatus,
        output: output,
        process_status: process_status
    }
  end
end
end

