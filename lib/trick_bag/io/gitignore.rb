module TrickBag
module Io


module Gitignore

  module_function

  def list_ignored_files(ignore_spec = File.readlines('.gitignore'))
    raise ArgumentError.new('ignore_spec must be an Array') unless ignore_spec.is_a?(Array)
    ignore_list = ignore_spec.each_with_object([]) do |exclude_mask, ignore_list|
      exclude_mask << '**/*' if exclude_mask[-1] == '/'
      exclude_files = Dir.glob(exclude_mask, File::FNM_DOTMATCH)
      ignore_list.concat(exclude_files)
    end

    ignore_list.sort!
    ignore_list.uniq!
    ignore_list.delete('.')
    ignore_list.delete('..')
    ignore_list
  end
end

end
end

