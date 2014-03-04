module TrickBag
module Validations
module HashValidations
  module_function

  # Looks to see which keys, if any, are missing from the hash.
  # @return an array of missing keys (empty if none)
  def missing_hash_entries(hash, keys)
    keys.reject { |key| hash.keys.include?(key) }
  end

  # Looks to see which keys, if any, are missing from the hash.
  # @return nil if none missing, else comma separated string of missing keys.
  def missing_hash_entries_as_string(hash, keys)
    missing_keys = missing_hash_entries(hash, keys)
    missing_keys.empty? ? nil : missing_keys.join(', ')
  end

end
end
end
