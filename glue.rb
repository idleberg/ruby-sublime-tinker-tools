#!/usr/bin/env ruby

=begin
    sublime-glue 0.1 – http://github.com/idleberg/sublime-tinkertools
    
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

require "json"
require "nokogiri"

# Configuration
delete_snippets = false

meta_info = <<-EOF
\nsublime-glue, version 0.1
The MIT License
Copyright (c) 2014 Jan T. Sott\n
EOF

puts meta_info

# Get output name from argument
unless ARGV.count == 1 
    puts "Error: Expecting 1 argument, passed #{ARGV.count}"
    exit
else 
    output = ARGV[0]
    unless output.end_with? ".sublime-completions"
        output += ".sublime-completions"
    end
end 

# Initialize variables
counter  = 0
scope    = nil;
snippets = Array.new

# Iterate over snippets in current directory
Dir.glob("*.sublime-snippet") do |item|

    puts "< Reading \"#{item}\""

    file = File.read(item)
    xml = Nokogiri::XML(file)

    scope = xml.xpath("//scope")[0].text.strip
    trigger = xml.xpath("//tabTrigger")[0].text.strip

    # Break if empty
    next if scope.to_s.empty? || trigger.to_s.empty?

    xml.xpath("//content").each do |node|
        contents = node.text.strip
        snippets << {:trigger => trigger, :contents => contents }
    end

    # Delete completions
    if delete_snippets == true
        puts "x Deleting \"#{item}\""
        File.delete(item)
    end

    counter += 1
end

unless scope.to_s.empty? || snippets.to_s.empty?

    # Create object
    completions = {:generator => "http://github.com/idleberg/sublime-tinkertools", :scope => scope, :completions => snippets}

    # Write to JSON
    puts "> Writing \"#{output}\"\n\n"
    File.open(output,"w") do |f|
      f.write(JSON.pretty_generate(completions))
    end

end

# Game Over
if counter == 0
    puts "No files found"
elsif counter == 1
     puts "Wrote #{counter} snippet to #{output}"
else
    puts "Wrote #{counter} snippets to #{output}"
end