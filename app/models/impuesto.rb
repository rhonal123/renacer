class Impuesto < ApplicationRecord




	def self.iva id 
		id ||= 1 
		find(id)
	end 

end
