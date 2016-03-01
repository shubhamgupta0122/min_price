#!/usr/bin/env ruby

require './minPrice.rb'

min = MinPrice.new

ARGV.each do |q|

	puts "\nSearching for #{q}\n"
	print "--------------"
	q.length.times { print "-" }
	print "\n"

	# Call the actual logic
	puts min.search_all("#{q}")
end