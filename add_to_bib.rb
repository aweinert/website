#!/usr/bin/env ruby

require 'bibtex'

bib_names = [:conference, :journal, :techreport, :thesis, :unpublished]
$bibs = { 
	:conference => "_C_onference Paper",
	:journal => "_J_ournal Paper",
	:techreport => "Technical _R_eport",
	:thesis => "_T_hesis",
	:unpublished => "_U_npublished Paper"
}
shortcuts = {
	'C' => :conference,
	'J' => :journal,
	'R' => :techreport,
	'T' => :thesis,
	'U' => :unpublished
}

puts "What kind of paper do you want to add?"
for i in 1..(bib_names.length)
	puts "#{i}) #{$bibs[bib_names[i-1]]}"
end
user_choice = gets.chomp

user_choice_bib = nil
begin
	user_choice_int = Integer(user_choice)
	user_choice_bib = bib_names[user_choice_int - 1]
	if user_choice_int < 1 or 5 < user_choice_int
		user_choice_bib = nil
	end
	error_string = "Please choose one of the given bibliographies (1-5), #{user_choice_int} is not a valid choice"
rescue
	user_choice_bib = shortcuts[user_choice.upcase]
	error_string = "#{user_choice} is not a valid shortcut"
end

if user_choice_bib == nil
	puts error_string
	abort("Exiting")
end


def print_header(category)
	puts "=" * 80
	puts "== " + $bibs[category].ljust(36, ' ') + " " + ("=" * 40)
	puts "=" * 80
end
print_header(user_choice_bib)

filename = '_bibliography/' + user_choice_bib.to_s + '.bib'
if File.file?(filename)
	b = BibTeX.open(filename)
	for entry_id in 1..(b.size)
		entry = b[entry_id - 1]
		puts "#{entry_id.to_s}: #{entry.to_s}"
		puts ""
	end
else
	puts "No entries currently"
end
puts ""
