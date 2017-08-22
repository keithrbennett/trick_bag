module TrickBag
module Io

# This module implements in Ruby the behavior of git's handling of the .gitignore file.
# It assumes that the current working directory is the directory of the .gitignore file.

module Gitignore

  module_function

  # Lists files that exist that would be ignored by git based on the .gitignore file
  # You may provide an Enumerable with the values that would normally be in the .gitignore file.
  def list_ignored_files(ignore_spec = File.readlines('.gitignore'))
    ignore_list = ignore_spec.each_with_object([]) do |exclude_mask, ignore_list|
      exclude_mask << '**/*' if exclude_mask[-1] == '/'
      exclude_files = Dir.glob(exclude_mask, File::FNM_DOTMATCH)
      ignore_list.concat(exclude_files)
    end

    ignore_list.sort!
    ignore_list.uniq!
    ignore_list.delete('.')
    ignore_list.delete('..')
    ignore_list.reject! { |filespec| File.directory?(filespec) }
    ignore_list
  end


  # Lists files that exist that would *NOT* be ignored by git based on the .gitignore file
  # You may provide an Enumerable with the values that would normally be in the .gitignore file.
  def list_included_files(ignore_spec = File.readlines('.gitignore'))
    all_files = Dir.glob('**/*', File::FNM_DOTMATCH).reject do |filespec|
      File.directory?(filespec)
    end
    all_files - list_ignored_files(ignore_spec)
  end
end

end
end

