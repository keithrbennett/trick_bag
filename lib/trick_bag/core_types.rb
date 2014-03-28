module TrickBag
module CoreTypes

  module_function

  def clone_hash_except(source_hash, keys_to_delete)
    new_hash = source_hash.clone
    keys_to_delete.each { |key| new_hash.delete(key) }
    new_hash
  end

end
end
