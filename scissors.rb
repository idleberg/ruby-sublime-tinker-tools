#!/usr/bin/env ruby
# sublime-scissors http://github.com/idleberg/sublimetext-scissors

require "builder"
require "oj"

# Configuration
to_subfolder        = true
delete_completions  = false

# Snippets are created based on trigger-names. Here you define which characters
# you want to filter before creating a snippet file
trigger_filter = [
    [" ",   "_"],
    ["/", ""],
    ["\t",  "-"]
]

# Define which characters you want to substitute in the snippet
contents_filter = [
    ['\\$',   '\$'],
    ['\"',    '"']
]

meta_info = <<-EOF
\nsublime-scissors, version 0.0.6
The MIT License
Copyright (c) 2014 Jan T. Sott
EOF

# Methods
def product_xml(scope, trigger, contents)
    xml = Builder::XmlMarkup.new( :indent => 2 )
    xml.comment! "http://github.com/idleberg/sublimetext-scissors"
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

counter = 0

# Iterate over completions in current directory
Dir.glob("*.sublime-completions") do |completions|

    puts "\n<< Reading \"#{completions}\""

    json = File.read(completions)
    parsed = Oj.load(json)

    scope = parsed["scope"]

    # Iterate over completions in JSON
    parsed["completions"].each do |line|
        trigger  = line['trigger']
        contents = line['contents'].to_s

        # Break if empty
        next if trigger.to_s.empty? || contents.to_s.empty?

        # Run filters
        trigger = filter_str(trigger, trigger_filter)
        contents = filter_str(contents, contents_filter)

        # Set target directory
        if to_subfolder == true
            dir = File.basename(completions, ".*")

            unless Dir.exists?(dir)
                Dir.mkdir(dir)
            end
        else
            dir = "."
        end

        # Write snippets
        File.open("#{dir}/#{trigger}.sublime-snippet", "w") do |snippet|
          puts ">> Writing \"#{trigger}.sublime-snippet\""
          snippet.write(product_xml(scope, trigger, contents))   
        end
    end

    # Delete completions
    if delete_completions == true
        puts "^^ Deleting \"#{completions}\""
        File.delete(completions)
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