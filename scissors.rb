#!/usr/bin/env ruby
# sublime-scissors http://github.com/idleberg/sublimetext-scissors

require "builder"
require "oj"

# Configuration
$scope           = "text.html"
$replace_strings = [
    [" ",   "_"],
    ["\t",  "-"]
]

meta_info = <<-EOF
\nsublime-scissors, version 0.0.1
The MIT License
Copyright (c) 2014 Jan T. Sott
EOF

# Methods
def product_xml(trigger, contents)
    xml = Builder::XmlMarkup.new( :indent => 2 )
    xml.comment! "Converted with sublime-scissors — http://github.com/idleberg/sublimetext-scissors"
    xml.snippet do |el|
        el << "  <content><![CDATA[\n"+contents+"\n]]><content>\n"
        el.tabTrigger trigger
        el.scope $scope
    end
end

puts meta_info

# Iterate over completions in current directory
Dir.glob("*.sublime-completions") do |file|

    puts "\n<< Reading \"#{file}\""

    json = File.read(file)
    parsed = Oj.load(json)

    # Iterate over completions in JSON
    parsed["completions"].each do |line|
        trigger  = line['trigger']
        contents = line['contents'].to_s

        # Break if empty
        next if trigger.to_s.empty? || contents.to_s.empty?

        # Replace spaces in triggers
        $replace_strings.each do |needle, replacement|
            trigger = trigger.to_s.gsub(needle, replacement)
        end

        # Write snippets
        File.open("#{trigger}.sublime-snippet", "w") do |snippet|
          puts ">> Writing \"#{trigger}.sublime-snippet\""
          snippet.write(product_xml(trigger, contents))   
        end
    end

    # Game Over
    puts "\nCompleted."
end