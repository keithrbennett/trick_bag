# Supports access to nested hashes with a string instead of multiple []'s.
# Inspired by Josh Szmajda's dot_notation gem at https://github.com/joshsz/dot_notation,

module TrickBag
module CollectionAccess

  module_function

  def access(collection, string, separator = '.')
    keys = string.split(separator)
    puts "keys:"
    puts keys
    keys.inject(collection) do |object, key|
      key = key.to_i if object.is_a?(Array)
      object[key]
    end
  end

end
end

