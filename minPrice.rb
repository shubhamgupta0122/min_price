require 'mechanize'
require 'yaml'

class MinPrice

	attr_accessor :sites
	
	def initialize()
		@agent = Mechanize.new
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
			{site_name: qsite[:name], item_name: name, item_price: price}
		else
			"Error Occured"
		end
	end

	def search_all(qword)
		mutex = Mutex.new
		results = []
		threads = []
		@sites = YAML.load_file('sites.yml')
		@sites.each do |site|
			threads << Thread.new do
				result = search_site(qword, site[:name])
				mutex.synchronize do
					results << result
				end
			end
		end
		threads.each do |t|
			t.join
		end
		results
	end

end