# Sublime Text Tinkertools

Two Ruby scripts to convert [Sublime Text](http://www.sublimetext.com/) completions to snippets and vice versa

## Installation

1. Clone the repository `git clone https://github.com/idleberg/sublime-tinkertools.git`
2. Change directory `cd sublime-tinkertools.git`
3. Install Gems using [Bundler](http://bundler.io/) `bundle install`

## Usage

### scissors.rb

Cuts up `sublime-completions` into smaller `sublime-snippet` files. You can set the following configuration option in the header of the script.

* `to_subfolder` writes snippets to a subfolder when set to `true`
* `delete_completions` deletes the completion files after conversion
* `trigger_filter` define rules to replace strings in `trigger` before using its name to create a file
* `contents_filter` define rules to replace strings in `completion` before writing it to a snippet

Place your `sublime-completions` to the same directory as the Ruby script and run `./scissors.rb`.

### glue.rb

Glues together `sublime-snippet` files to form one big `sublime-completions` file. You can set the following configuration option in the header of the script.

* `delete_snippets` deletes the snippet files after conversion

Special characters are automatically escaped, hence the missing filter option!

## License

The MIT License (MIT)

Copyright (c) 2014 Jan T. Sott

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## Donate

You are welcome support this project using [Flattr](https://flattr.com/submit/auto?user_id=idleberg&url=https://github.com/idleberg/sublime-tinkertools) or Bitcoin `17CXJuPsmhuTzFV2k4RKYwpEHVjskJktRd`