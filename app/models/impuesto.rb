class Impuesto < ApplicationRecord

	def self.iva id 
		find(id || 1 )
	end 

end
