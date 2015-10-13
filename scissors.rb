#!/usr/bin/env ruby

=begin
    sublime-scissors
    http://github.com/idleberg/sublime-tinkertools
    
    The MIT License (MIT)
    
    Copyright (c) 2014, 2015 Jan T. Sott
    
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:
    
    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
=end

$version = "0.2.2"

require "builder"
require "json"
require "optparse"

# Snippets are created based on trigger-names. Here you define which characters
# you want to filter before creating a snippet file
trigger_filter = [
    [" ",   "_"],
    [/[\x00\/\\:\*\?\"\$<>\|]/, "_"],
    ["\t",  "-"]
]

# Define which characters you want to substitute in the snippet
contents_filter = [
    ['\\$',   '\$'],
    ['\"',    '"']
]


# Methods
def product_xml(scope, trigger, contents)
    xml = Builder::XmlMarkup.new( :indent => 2 )
    xml.comment! "http://github.com/idleberg/sublime-tinkertools"
    xml.snippet do |el|
        el << "  <content><![CDATA[\n"+contents+"\n]]></content>\n"
        el.tabTrigger trigger
        el.scope scope
    end
end

def filter_str(input, filter)
    filter.each do |needle, replacement|
        input = input.to_s.gsub(needle, replacement)
    end
    return input
end

def valid_json?(json)
    JSON.parse(json)
    true
rescue
    false
end


# Let's go
meta_info = <<-EOF
\nsublime-scissors, version #{$version}
The MIT License
Copyright (c) 2014-2015 Jan T. Sott\n
EOF

$chaos = false
$delete_input = false

# parse arguments
args = ARGV.count

ARGV.options do |opts|
    opts.banner = "Usage: [ruby] scissors.rb [options]"

    opts.on("-h", "--help", "prints this help") do
        puts meta_info
        puts opts
        exit
    end

    opts.on("-i", "--input=<file>", Array, "input file(s)") {
        |input| $input = input
    }

    opts.on("-D", "--delete-input", "delete input file(s) afterwards") {
        $delete_input = true
    }

    opts.on("-X", "--chaos", "don't organize snippets in folders") {
        $chaos = true
    }

    opts.on_tail("-v", "--version", "show version") do
        puts $version
        exit
    end

    opts.parse!
end

puts meta_info

# Get output name from argument
if args > 4
    puts "Error: Too many arguments passed (#{args})"
    exit
elsif $input == nil
    abort("Error: no input argument passed")
end

# Iterate over completions in current directory
Dir.glob($input) do |item|

    input_counter = 0
    output_counter = 0

    puts "Reading \"#{item}\""

    file = File.read(item)

    # validate file
    if (valid_json?(file) == false)
        abort("Error: Invalid JSON file '#{item}'")
    else
        json = JSON.load(file)
    end    

    scope = json["scope"]

    # Iterate over completions in JSON
    json["completions"].each do |line|
        trigger  = line['trigger']
        contents = line['contents'].to_s

        # Break if empty
        next if trigger.to_s.empty? || contents.to_s.empty?

        # Run filters
        output = filter_str(trigger, trigger_filter)
        contents = filter_str(contents, contents_filter)

        # Set target directory
        if $chaos == false
            dir = File.basename(item, ".*")

            unless Dir.exists?(dir)
                Dir.mkdir(dir)
            end
        else
            dir = "."
        end

        # Write snippets
        File.open("#{dir}/#{output}.sublime-snippet", "w") do |snippet|
          puts "Writing \"#{output}.sublime-snippet\""
          snippet.write(product_xml(scope, trigger, contents))
          output_counter += 1
        end
    end

    # Delete completions
    if $delete_input == true
        puts "Deleting \"#{item}\""
        File.delete(item)
    end

    input_counter += 1

    # Game Over
    if input_counter == 1
        puts "Cut #{input_counter} file into #{output_counter}"
    else
        puts "Cut #{input_counter} files into #{output_counter}"
    end

    puts ""
end

puts "Completed."
