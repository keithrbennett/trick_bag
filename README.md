[![Build Status](https://travis-ci.org/keithrbennett/trick_bag.svg?branch=master)](https://travis-ci.org/keithrbennett/trick_bag)

# TrickBag

This gem is a collection of useful classes and modules for Ruby development.


## Installation

Add this line to your application's Gemfile:

    gem 'trick_bag'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install trick_bag

## Usage

Really the best way to understand the usage is to look at the unit tests in the spec directory tree,
the comments in the source files, and the source code itself.

That said, here is a summary:

#### CollectionAccess

* `#access` - access a deeply nested collection more simply, 
e.g. `TrickBag::CollectionAccess::access('customer', 'contact_info', 'address', 'city')` instead of `customer['contact_info']['address']['city]` 
* `accessor` - returns lambda for above to simplify use
* `LinkedList` - a linked list implementation in Ruby

## Enumerables

* `BufferedEnumerable` - enumerable handling the high level timing of buffering and fetching; you provide fetcher
and (optionally) fetch notifier callables
* `CompoundEnumberable` - an enumerator used to provide all combinations of a set of Enumerables.
* `EndlessLastEnumerable` - wraps another enumerable, and after it is exhausted, yields the same value on successive calls
* `FileLineReader` - Reads a file containing strings, one on each line, and feeds them
  in its each() method.  Strips all lines' leading and trailing whitespace,
  and ignores all empty lines and lines beginning with the comment character `#`.
  Especially useful in reading configuration files.
* `FilteredEnumerable` - like `my_enumerable.lazy.select { ... }.lazy`, but supports changing the filter at any time

## Formatters

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
* `Formatters.array_diff` - returns a nicely formatted output of the difference between 2 arrays
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


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
