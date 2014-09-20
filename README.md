# sublime-scissors

A simple Ruby scripts that cuts up Sublime Text completions and creates snippets from the pieces. Snippets are stricter than standard completions, as you can only trigger a snippet after typing the correct prefix. They also have a higher priority over completions. One of the advantages of completions is, of course, that they are often easier to create, especially when copy&paste is involved. Using sublime-scissors, you can create completions and later convert them to snippets.

## Installation

1. Clone the repository `git clone https://github.com/idleberg/sublimetext-scissors.git`
2. Change directory `cd sublimetext-scissors.git`
3. Install Gems using [Bundler](http://bundler.io/) `bundle install`

## Usage

There are several configuration options available in the header of `scissors.rb` and the should be pretty self-explanatory.

* `$to_subfolder`lets you write all snippets to a subfolder matching the name of your completions
* `$delete_completions` will delete the completion files after the conversion
* `$replace_strings` lets you define rules to replace strings in triggers before creating files

Place your `sublime-completions` to the same directory as the Ruby script and run `./scissors.rb` or `ruby scissors.rb`.

## License

The MIT License (MIT)

Copyright (c) 2014 Jan T. Sott

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## Donate

You are welcome support this project using [Flattr](https://flattr.com/submit/auto?user_id=idleberg&url=https://github.com/idleberg/sublimetext-scissors) or Bitcoin `17CXJuPsmhuTzFV2k4RKYwpEHVjskJktRd`