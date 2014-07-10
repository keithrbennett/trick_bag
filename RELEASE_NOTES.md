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
