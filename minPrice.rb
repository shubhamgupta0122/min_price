require 'mechanize'
require 'yaml'

class MinPrice
	def initialize()
		
		@agent = Mechanize.new
		@sites = YAML.load_file('sites.yml')

	end

	def search_site(qword, qsite)
		qsite = @sites.select { |site| site[:name] == qsite }
		qsite = qsite[0]
		page = @agent .get ( qsite[:url] .sub("%s", qword) )
		name = page .at_xpath( qsite[:item_name] ) .text .strip
		price = page .at_xpath( qsite[:item_price] ) .text
		price = price .sub( "Rs." , "" ) .delete(",") .strip .delete(" ") .to_i
		{name: name, price: price}
	end

	def search_all(qword)
		@sites.each do |site|
			puts "Searching #{site[:name]}..."
			puts "#{site[:name]} => \n#{search_site(qword, site[:name])}\n\n-----------"
		end
	end

end

h = MinPrice.new

ARGV.each do |q|
	puts "\n\nSearching for #{q}\n"
	h.search_all("#{q}")
end
