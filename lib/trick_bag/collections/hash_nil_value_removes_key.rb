# Behaves like a standard Ruby hash, except when a value is set to nil,
# in which case the key is removed.

class HashNilValueRemovesKey < Hash

  def []=(key, value)
    if value.nil?
      delete(key)
    else
      super
    end
  end
end