module SalesHelper
	def add_purchase_link(name)
		link_to_function name do |page|
			page.insert_html :bottom, :tasks, :partial => 'purchase' , :object => Purchase.new
		end
	end
end
