# Load all *.rb files in lib/trick_bag and below.
# Use a lambda so that the intermediate variables do not survive this file.
->() {
  start_dir = File.join(File.dirname(__FILE__), 'trick_bag') # the lib directory
  file_mask = "#{start_dir}/**/*.rb"
  Dir[file_mask].each { |file| require file }
}.()
