# Sublime Text Tinkertools

[![The MIT License](https://img.shields.io/badge/license-MIT-orange.svg?style=flat-square)](http://opensource.org/licenses/MIT)
[![GitHub](https://img.shields.io/github/release/idleberg/sublime-tinkertools.svg?style=flat-square)](https://github.com/idleberg/sublime-tinkertools/releases)

Two Ruby scripts to convert [Sublime Text](http://www.sublimetext.com/) completions into snippets and vice versa

## Installation

1. Clone the repository `git clone https://github.com/idleberg/sublime-tinkertools.git`
2. Change directory `cd sublime-tinkertools`
3. Install Gems using [Bundler](http://bundler.io/) `bundle install`

## Usage

### scissors.rb

Use scissors to cut a completion file into many snippet files.

#### Examples

```bash
# Convert single file
scissors.rb -i AppleScript.sublime-completions

# Use quotes with wildcards
scissors.rb -i "*.sublime-completions"

# Delete input file on completion
scissors.rb -i Ruby.sublime-completions -D

# Do not organize snippets in sub-folders
scissors.rb -i AppleScript.sublime-completions -X
```

#### Filters

You can define custom filters in the header of the script:

* `trigger_filter` define rules to replace strings in `trigger` before using its name to create a file
* `contents_filter` define rules to replace strings in `completion` before writing it to a snippet

### glue.rb

Use glue to merge several snippets into a single completions file.

#### Examples

```bash
# Use quotes with wildcards
glue.rb -i "snippets/*" -o AppleScript.sublime-completions

# Delete input file on completion
glue.rb -i "snippets/*" -o Ruby.sublime-completions -D
```

#### Filters

Special characters are automatically escaped, no custom filters available at this moment.

## License

This work is licensed under the [The MIT License](LICENSE).

## Donate

You are welcome support this project using [Flattr](https://flattr.com/submit/auto?user_id=idleberg&url=https://github.com/idleberg/sublime-tinkertools) or Bitcoin `17CXJuPsmhuTzFV2k4RKYwpEHVjskJktRd`