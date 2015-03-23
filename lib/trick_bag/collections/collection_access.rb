# Supports access to nested hashes with a string instead of multiple []'s.
# Inspired by Josh Szmajda's dot_notation gem at https://github.com/joshsz/dot_notation,

module TrickBag
module CollectionAccess

  module_function


  # Accesses a collection with a single string that represents n levels of depth.
  # See the spec file for examples, but here's one:
  #
  # h = { 'h' => ['a', 'b'] }
  # CollectionAccess.access(h, 'h.1') => 'b'
  #
  # If an error is raised while trying to access the value with a given key,
  # an error will be raised showing that error plus the context of which
  # key failed, as in:
  #
  # Error occurred processing key [x.1] in [x.1.2]: undefined method `[]' for nil:NilClass
  #
  # @param collection the collection to access
  # @param key_string the string representing the keys to use
  # @param separator the string to use to separate the nesting levels (default = '.')
  def access(collection, key_string, separator = '.', nil_strategy = :return)

    is_number_string = ->(s) do
      begin
        Integer(s)
        true
      rescue
        false
      end
    end

    keys = key_string.split(separator)
    return_object = collection

    keys.each_with_index do |key, index|

      if return_object.nil?
        if nil_strategy == :return
      end
      if return_object.kind_of?(Array)
        unless is_number_string.(key)
          raise "Key is not a number string: #{key}"
        end
        key = key.to_i
      end

      begin
        return_object = return_object[key]
      rescue => e
        this_key = keys[0..index].join(separator)
        raise "Error occurred processing key [#{this_key}] in [#{key_string}]: #{e}"
      end
    end
    return_object
  end


  # Like access, but returns a lambda that can be used to access a given collection.
  # Since lambdas can be called with the subscript operator,
  # using it can resemble regular hash or array access.
  # If you don't like this you can use '.call' or '.()' instead.
  #
  # An example:
  #
  # h = { 'h' => ['a', 'b'] }
  # accessor = CollectionAccess.accessor(h)
  # accessor['h.1']    # => 'b'
  # or
  # accessor.('h.1')    # => 'b'
  def accessor(collection, separator = '.')
    ->(key_string) { access(collection, key_string, separator) }
  end

end
end
