## v0.66.0

* Add TrickBag::Io::Gitignore.list_ignored_files.


## v0.65.1

* Fix bug in TrickBag::Validations when raise_on_missing_keys was passed an array.


## v0.65.0
* Add ability to pass values through print() to TextModeStatusUpdater's text generator. Version 0.65.0.


## v0.64.5

* Modified .travis.yml. as per suggestion on web to fix bundler problem:
NoMethodError: undefined method `spec' for nil:NilClass


## v0.64.4

* Fix net-ssh version error on Ruby versions < 2.  v0.64.2 did not work.


## v0.64.3

* Fix retry_until_true_or_timeout bug.


## v0.64.2

* Fix net-ssh version error on Ruby versions < 2.


## v0.64.1

* Minor documentation fix.


## v0.64.0

* Add BinaryToHexAndAscii formatter.


## v0.63.1

* Put SshOutputReader in TrickBag::Networking module.


## v0.63.0

* Add SshOutputReader.


## v0.62.1

* Reinstated thread.kill in Timing.try_with_timeout.


## v0.62.0

* Added Timing.try_with_timeout.

## v0.61.0

* Added Timing::Elapser.


## v0.60

* CollectionAccess methods now support an array of keys/subscripts instead of
  a string.


## v0.59

* Timing.retry_until_true_or_timeout now optionally takes a code block instead of a lambda.
  Also, method signature's parameter order has changed.  This is a breaking change for users
  of this method. A descriptive error has been provided to explain if this happens.

## v0.58.1

* For KmgtNumericString, support returning of nil/false on nil input.


## v0.58.0

* Added KmbtNumericString, Formatters.thousands_separated.


## v0.57.0

* Removed most class methods from Bitmap and put them in new BitMapping module.


## v0.56.0

* Added Bitmap class/support.


## v0.55.0

* Version confusion; this should have been the "real" 0.54.0.


## v0.54.0

* Added RegexStringListAnalyzer '*_as_strings' methods.


## v0.53.0

* Added RegexStringListAnalyzer.


## v0.52.0

* Added RegexValidations.


## v0.51.0

* Add CollectionAccess access and accessor methods.


## v0.50.0

* On MultiCounter, fixed percent_of_total_hash, added fraction_of_total_hash.


## v0.49.0

* Corrected name from from_array to from_enumerable.


## v0.48.0

* Add TrickBag::Numeric::MultiCounter#total_count and #percent_of_total_hash.


## v0.47.0

* Remove array_as_multiline_string; it's too similar to array.join("\n").


## v0.46.0

* Add array_diff and array_as_multiline_string to Formatters.


## v0.45.3

* Upgrade to RSpec 3.0.  Other minor improvements.


## v0.45.2

* Fix gem dependency versions; remove refs to pry & guard; doc fixes & additions.


## v0.45.1

* Fix commit omissions.


## v0.45.0

* Add GemDependencyScript.


## v0.44.0

* Fix missing require 'ostruct' in erb_renderer.rb.
* Simplify implementation of determining missing keys.
* Rename any?, all?, none? to any_with_object?, etc.


## v0.43.0

* Added any?, all?, none?.


## v0.42.0

* Added ErbRenderer class, which functions as a bag of values for ERB rendering.


## v0.41.0

*  Added Timing.benchmark().


## v0.40.0

* Added Validations.raise_on_invalid_value.
* Moved all validations into same module.


## v0.39.0

* Added CoreTypes.clone_hash_except.
* Added FileLineReader.to_s.
git


## v0.38.0

* Added documentation.
* Changed string returned by missing_hash_entries_as_string to be array.inspect.
* TextModeStatusUpdater.print now calls to_s on lambda's return value.
* Modified EndlessLastEnumerable so it could be initialized with any Enumerable, not only an Array.
* Added documentation, tests that enumerators return enumerables when yield is called without a block.
* Changed FilteredEnumerable default filter to be a lambda that always returns true.
* Added LinkedList#to_ary.


## v0.37.0

* Fixed: 'os' gem dependency was not properly specified in gemspec.


## v0.36.0

* Add System module w/lsof and command_available? methods.


## v0.35.0

* Added start_pos and max_count accessors to FileLineReader.


## v0.34.0

* Added FileLineReader, StartMax.  Added strategies to dos2unix.


## v0.33.0

* Added dos2unix and dos2unix! to Formatters.


## v0.32.0

* Added timestamp, replace_with_timestamp in Formatters.


## v0.31.0

* Added EndlessLastEnumerable.
* Added Formatter module with duration_to_s and end_with_nl.
* Deleted IntegerDispenser.  It had little that [].cycle.to_enum couldn't offer.
* In HashValidations: Add raise_on_missing_keys, permit passing either array or list.


## v0.30.0

* Initial public version.
