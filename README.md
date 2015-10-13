# Sublime Text Tinkertools

Two Ruby scripts to convert [Sublime Text](http://www.sublimetext.com/) completions to snippets and vice versa

## Installation

1. Clone the repository `git clone https://github.com/idleberg/sublime-tinkertools.git`
2. Change directory `cd sublime-tinkertools.git`
3. Install Gems using [Bundler](http://bundler.io/) `bundle install`

## Usage

### scissors.rb

Use `scissors.rb -i input_file [options]` to cut completion file into single snippet files. You can define several filters in the header of the script:

* `trigger_filter` define rules to replace strings in `trigger` before using its name to create a file
* `contents_filter` define rules to replace strings in `completion` before writing it to a snippet

### glue.rb

Use `glue.rb -i input_file -o output_file` to merge several snippets into a single completions file. You can set the following configuration option in the header of the script.

## License

This work is licensed under the [The MIT License](LICENSE).

## Donate

You are welcome support this project using [Flattr](https://flattr.com/submit/auto?user_id=idleberg&url=https://github.com/idleberg/sublime-tinkertools) or Bitcoin `17CXJuPsmhuTzFV2k4RKYwpEHVjskJktRd`