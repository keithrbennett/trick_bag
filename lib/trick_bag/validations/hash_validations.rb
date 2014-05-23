module TrickBag
module Validations

  module_function

  # Looks to see which keys, if any, are missing from the hash.
  # @return an array of missing keys (empty if none)
  def missing_hash_entries(the_hash, *keys)
    # Support passing either an Array or multiple args:
    if keys.size == 1 && keys.first.is_a?(Array)
      keys = keys.first
    end

    keys - the_hash.keys
  end


  # Looks to see which keys, if any, are missing from the hash.
  # @return nil if none missing, else comma separated string of missing keys.
  def missing_hash_entries_as_string(the_hash, *keys)
    missing_keys = missing_hash_entries(the_hash, *keys)
    missing_keys.empty? ? nil : missing_keys.inspect
  end

  # Checks to see that all passed keys are present in the hash.
  # If not, an exception is raised, with a message string listing the missing keys.
  def raise_on_missing_keys(the_hash, *keys)
    missing_entries_string = missing_hash_entries_as_string(the_hash, keys)
    if missing_entries_string
      raise "The following required options were not provided: #{missing_entries_string}"
    end
  end
end
end

