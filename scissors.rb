#!/usr/bin/env ruby

=begin
    sublime-scissors 0.1 – http://github.com/idleberg/sublime-tinkertools
    
    The MIT License (MIT)
    
    Copyright (c) 2014 Jan T. Sott
    
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

require "builder"
require "json"

# Configuration
to_subfolder        = true
delete_completions  = false

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

meta_info = <<-EOF
\nsublime-scissors, version 0.1
The MIT License
Copyright (c) 2014 Jan T. Sott
EOF

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

puts meta_info

# Get output name from argument
if ARGV.count > 1 
    puts "\nError: Too many arguments passed (#{ARGV.count})"
    exit
elsif ARGV.count == 0
    input = "*.sublime-completions"
else 
    input = ARGV[0]
    unless input.end_with? ".sublime-completions"
        input += ".sublime-completions"
    end
end 

counter = 0

# Iterate over completions in current directory
Dir.glob(input) do |item|

    puts "\n< Reading \"#{item}\""

    json = File.read(item)
    parsed = JSON.load(json)

    scope = parsed["scope"]

    # Iterate over completions in JSON
    parsed["completions"].each do |line|
        trigger  = line['trigger']
        contents = line['contents'].to_s

        # Break if empty
        next if trigger.to_s.empty? || contents.to_s.empty?

        # Run filters
        output = filter_str(trigger, trigger_filter)
        contents = filter_str(contents, contents_filter)

        # Set target directory
        if to_subfolder == true
            dir = File.basename(item, ".*")

            unless Dir.exists?(dir)
                Dir.mkdir(dir)
            end
        else
            dir = "."
        end

        # Write snippets
        File.open("#{dir}/#{output}.sublime-snippet", "w") do |snippet|
          puts "> Writing \"#{output}.sublime-snippet\""
          snippet.write(product_xml(scope, trigger, contents))   
        end
    end

    # Delete completions
    if delete_completions == true
        puts "x Deleting \"#{item}\""
        File.delete(item)
    end

    counter += 1
end

# Game Over
if counter == 0
    puts "\nNo files found"
elsif counter == 1
     puts "\nConverted #{counter} file"
else
    puts "\nConverted #{counter} files"
end