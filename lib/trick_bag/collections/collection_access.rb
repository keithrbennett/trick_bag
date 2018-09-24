# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# IMPORTANT: MOST OF THE FUNCTIONALITY OF THIS MODULE HAS BEEN PROVIDED IN
# THE RUBY 2.3+ RUNTIME IN THE FORM OF THE dig METHOD ON HASHES AND ARRAYS.
# USING dig IS RECOMMENDED UNLESS YOU NEED A FEATURE OF THIS MODULE NOT SUPPORTED BY IT.
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#
# Supports access to nested hashes, arrays, etc., with a string instead of multiple []'s.
# (e.g. 'myhostname.interfaces.0' instead of ['myhostname']['interfaces'][0])
#
# Inspired by Josh Szmajda's dot_notation gem at https://github.com/joshsz/dot_notation.
#
# The examples below assume a variable 'h' containing { x: [:red, :green, :blue] }
#
# 2 approaches are supported:
#
# 1) a method named 'access' to which you pass the aggregate object (collection)
#    the keys as a single string or as an array, and, optionally, the separator
#    character (which defaults to '.')
#
# 2) a lambda returned by the 'accessor' method that holds on to the collection so that
#    you can call the lambda as if it were the object itself. This lambda calls the
#    aforementioned 'access' method to do the main work.
#
# Please see the documentation of the methods below for further information.


module TrickBag
module CollectionAccess

  class Error < RuntimeError; end

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
  # @param key_string_or_array the string or array representing the keys to use
  # @param separator the string to use to separate the keys, defaults to '.'
  def access(collection, key_string_or_array, separator = '.')

    to_integer = ->(object) do
      begin
        Integer(object)
      rescue
        raise Error.new("Key cannot be converted to an Integer: #{object}")
      end
    end

    get_key_array = -> do
      case key_string_or_array
        when Array
          key_string_or_array
        when String
          key_string_or_array.split(separator)
        else
          raise Error.new("Invalid data type: #{key_string_or_array.class}")
      end
    end

    keys = get_key_array.()
    return_object = collection

    keys.each_with_index do |key, index|
      key = to_integer.(key) if return_object.kind_of?(Array)

      begin
        return_object = return_object[key]
      rescue => e
        this_key = keys[0..index].join(separator)
        raise Error.new("Error occurred processing key [#{this_key}] in [#{key_string_or_array}]: #{e}")
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
    ->(*args) do
      key_string = (args.size == 1) ? args.first : args.map(&:to_s).join(separator)
      access(collection, key_string, separator)
    end
  end

end
end
