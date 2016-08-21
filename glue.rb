#!/usr/bin/env ruby

=begin
    sublime-glue 
    http://github.com/idleberg/sublime-tinkertools
    
    The MIT License (MIT)
    
    Copyright (c) 2014-2016 Jan T. Sott
    
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

$version = "0.3.0"

require "json"
require "nokogiri"
require "optparse"

# Configuration
delete_snippets = false

meta_info = <<-EOF
\nsublime-glue, version #{$version}
The MIT License
Copyright (c) 2014-2016 Jan T. Sott\n
EOF


# Methods
def valid_xml?(xml)
    Nokogiri::XML(xml) { |config| config.options = Nokogiri::XML::ParseOptions::STRICT }
    true
rescue
    false
end

$delete_input = false
$skip_desc = false

# parse arguments
args = ARGV.count

ARGV.options do |opts|
    opts.banner = "Usage: [ruby] glue.rb [options]"

    opts.on("-h", "--help", "prints this help") do
        puts meta_info
        puts opts
        exit
    end

    opts.on("-i", "--input=<file>", Array, "input file(s)") {
        |input| $input = input
    }

    opts.on("-o", "--output=<file>", String, "output file") {
        |output| $output = output
    }

    opts.on("-d", "--skip-description", "ignore snippet description") {
        $skip_desc = true
    }

    opts.on("-D", "--delete-input", "delete input file(s) afterwards") {
        $delete_input = true
    }

    opts.on_tail("-v", "--version", "show version") do
        puts $version
        exit
    end

    opts.parse!
end


# Let's go
puts meta_info

# Get output name from argument
if args < 2
    abort("Error: Expecting 2 arguments, passed #{args}")
elsif $input == nil
    abort("Error: no input argument passed")
elsif $output == nil
    abort("Error: no output argument passed")
end

# Initialize variables
counter  = 0
scope    = nil;
snippets = Array.new

# Iterate over snippets in current directory
Dir.glob($input) do |item|

    puts "Reading \"#{item}\""

    file = File.read(item)

    # validate file
    if (valid_xml?(file) == false)
        abort("Error: Invalid XML file '#{item}'")
    end

    xml = Nokogiri::XML(file)

    scope = xml.xpath("//scope")[0].text.strip
    trigger = xml.xpath("//tabTrigger")[0].text.strip

    if $skip_desc == false
        description = xml.xpath("//description")[0]

        # Add tab-delimited description
        if description != nil
            description = "\t" + description.text.strip
        end
    end

    # Break if empty
    next if scope.to_s.empty? || trigger.to_s.empty?

    xml.xpath("//content").each do |node|
        contents = node.text.strip
        snippets << {:trigger => "#{trigger}#{description}", :contents => contents }
    end

    # Delete completions
    if $delete_input == true
        puts "Deleting \"#{item}\""
        File.delete(item)
    end

    counter += 1
end

# Add extension if necessary
unless $output.end_with? ".sublime-completions"
    $output += ".sublime-completions"
end

unless scope.to_s.empty? || snippets.to_s.empty?

    # Create object
    completions = {:generator => "http://github.com/idleberg/sublime-tinkertools", :scope => scope, :completions => snippets}

    # Write to JSON
    puts "Writing \"#{$output}\"\n\n"
    File.open($output,"w") do |f|
      f.write(JSON.pretty_generate(completions))
    end

end

# Game Over
if counter == 0
    puts "No files found"
elsif counter == 1
     puts "Glued #{counter} piece into #{$output}"
else
    puts "Glued #{counter} pieces into #{$output}"
end
