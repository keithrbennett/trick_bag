![logo](logo/trickbag-logo-horizontal-color.png)

[![Build Status](https://travis-ci.org/keithrbennett/trick_bag.svg?branch=master)](https://travis-ci.org/keithrbennett/trick_bag)

# TrickBag

Assorted Ruby classes, modules, and methods to simplify and enhance your code.
 

## Installation

Add this line to your application's Gemfile:

    gem 'trick_bag'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install trick_bag

## Usage

The best ways to understand the usage are to look at a) the unit tests in the spec directory tree,
b) the comments in the source files, and c) the source code itself. That said, here is a summary:

### CollectionAccess

* `accessor` - returns lambda to simplify access to a deeply nested hash, as in 
  `customer_accessor['contact_info.address.city']`
  instead of `customer['contact_info']['address']['city']`
* `#access` - worker method for above, also publicly available for use; called as:
  `access(customer, 'contact_info', 'address', 'city')` 
* `LinkedList` - a linked list implementation in Ruby

### Enumerables

* `BufferedEnumerable` - enumerable handling the buffering and the timing of fetching;
  you provide fetcher and (optionally) fetch notifier callables
* `CompoundEnumberable` - an enumerator used to provide all combinations of a set of Enumerables.
* `EndlessLastEnumerable` - wraps another enumerable, and after it is exhausted, yields the same value on successive calls
* `FileLineReader` - Reads a file containing strings, one on each line, and feeds them
  in its each() method.  Strips all lines' leading and trailing whitespace,
  and ignores all empty lines and lines beginning with the comment character `#`.
  Especially useful in reading configuration files.
* `FilteredEnumerable` - like `my_enumerable.lazy.select { ... }.lazy`, but supports changing the filter at any time

### Formatters

* `BinaryToHexAndAscii` - formats bytes in hex and ASCII, e.g.: 
```
0x   0  00 07 0E 15 | 1C 23 2A 31 | 38 3F 46 4D | 54 5B 62 69  .....#*18?FMT[bi
0x  10  70 77 7E 85 | 8C 93 9A A1 | A8 AF B6 BD | C4 CB D2 D9  pw~.............
```
* `ErbRenderer` - convenience class  for ERB rendering; simplifies using a specific set of key/value pairs
  as opposed to the current binding
* `Formatters.duration_to_s` - formats number of seconds to string like `11 d, 13 h, 46 m, 40 s`
* `Formatters.end_with_n` - reverse of `String#chomp` - 
  useful for use with utilities like Diffy that complain about lines without line endings.
* `Formatters.timestamp` - returns a timestamp string suitable for use in file names
  in the year-month-day-hour-minute-second form, e.g. `2014-03-24_15-25-57`.
* `Formatters.replace_with_timestamp` - replaces a token with the timestamp, as in:
  `my-app-result-{dt}.txt` => `my-app-result-2014-03-24_15-25-57.txt`
  Especially useful for generating file names.
* `Formatters.dos2unix[!]` - formats a string with Unix line endings
* `Formatters.array_diff` - returns a nicely formatted string output of the difference 
  between 2 arrays
* `Formatters.string_to_verbose_char_list` - returns a list of chars in a string, 1 per line,
  with several representations of the values, e.g.:
```
     Index     Decimal        Hex              Binary    Character
     -----     -------        ---              ------    ---------
         0          97         61 x          110 0001 b       a
         1          49         31 x           11 0001 b       1
```  
* `Formatters.thousands_separated` - adds thousands separators to an Integer 
  string representation as appropriate


### Functional

These methods provide a shorthand for testing whether or not an object
meets an Enumerable of conditional callables.


### IO

* `Gitignore` - these methods simulate the results of git's file pattern matching
  based on the .gitignore file. They can be useful, for example,
  in determining which files to include in a gem build when git is not present.
* `Tempfiles.file_containing` - for the easy creation and deletion of a temp file
  populated with text, wrapped around the code block you provide.
* `TextModeStatusUpdater` - provides an updatable and customizable status/information
  line in a terminal, typically used to display progress.


### Meta

* `attr` methods provide cleaner and more concise creation of attribute methods that
  require control over accessibility (public, protected, private).
* `class?` - is this name the name of a class?
* `undef_class` - undefines a class; useful for unit testing code that dynamically creates classes.


### Networking

* `SshOutputReader` - Runs an ssh command, collecting the stdout and stderr produced by it.
Optionally a predicate can be specified that, when called with the
instance of this class, returns true to close the channel or false to continue
(for example, when a certain string appears in the command's output).
There are instance methods to return the most recent and all accumulated text
for both stdout and stderr, so the predicate can easily inspect the text.


### Numeric

* `Bitmapping` - methods for converting from binary string and bit array to number and back 
* `Bitmap` - a simple bitmap implementation, with several initialization methods
* `KmgtNumericString` - converts number strings with optional suffixes of [kKmMgGtT] to integers.
  Upper case letters represent powers of 1024, and lower case letters represent powers of 1000.
  Also supports ranges, e.g. '1k..5k' will be converted by to_range to (1000..5000).
* `Multicounter` - simplifies accumulating counts of multiple objects.
* `StartAndMax` - provides an object that will tell you if the number exceeds
  the starting point and if the number is >= the maximum (or if no maximum has been specified).
* `Totals` - provides methods for working with percent of total


### Operators

* `multi_eq` - returns whether or not _all_ values passed are equal to each other


### Timing

* `Elapser` - provides ways to specify and test for elapsed state
* `retry_until_true_or_timeout` -  calls a predicate proc repeatedly,
  sleeping the specified interval between calls, returning if the predicate returns true,
  and giving up after the specified number of seconds.
  Displays elapsed and remaining times on the terminal.
* `benchmark` - simplifies the output of benchmarking data with a text caption
* `try_with_timeout` - runs the passed block in a new thread, ensuring that its execution time
  does not exceed the specified duration.
  
  
### Validations

* hash validations - methods to see if any of the specified keys are missing from the hash,
  and a method to raise an error with descriptive message if so
* object validations - method to see if any of the specified instance variables are nil, and another
  method that raises an error with descriptive message if so
* `raise_on_invalid_value` - if the passed value is not in the list of valid values, raise an error
  with descriptive message
* regex validations - for working with multiple regexes and strings with which to match them  
  
  
### Core Types

`clone_hash_except` - creates a copy of a hash except for the specified keys (this functionality
is already included in Rails, but not in Ruby itself)


## Why?

This library was born when I was writing a lot of testing tools and data collection and analysis software.
At that time I also mentored a team of software testers using Ruby and Cucumber. I saw coding patterns that existed
in multiple places, in varying levels of functionality and quality, or sometimes, totally absent when
they would have been helpful. Why not implement these patterns once in a shared and tested library?

Some may be very thin layers over the underlying Ruby implementations (e.g. the _Elapser_ class),
and their usefulness may be questioned...but in the calling code, the use of these is more intention-revealing,
object oriented, and results in more concise calling code.

This gem's files, classes, and methods are for the most part isolated from each other and self-contained.
This means that if you like you can easily copy single methods or files from the gem and copy them into
your code base to eliminate a dependency on this gem. If you do this, then I suggest you include an
attribution to this gem so that future developers can consult it for fixes and enhancements.

## Logo

Logo designed and generously contributed by Anhar Ismail (Github: [@anharismail](https://github.com/anharismail), Twitter: [@aizenanhar](https://twitter.com/aizenanhar)).


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
