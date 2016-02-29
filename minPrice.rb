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
		
		name = page .at_xpath( qsite[:item_name] )
		price = page .at_xpath( qsite[:item_price] )
		
		if ( name && price )
			name = name.text.strip
			price = price.text.sub("Rs.","").delete(",").delete(" ").strip.to_i
			{name: name, price: price}
		else
			"Error Occured"
		end
	end

	def search_all(qword)
		@sites.each do |site|
			puts "Searching #{site[:name]}..."
			puts "#{search_site(qword, site[:name])}\n\n-----------"
		end
	end

end