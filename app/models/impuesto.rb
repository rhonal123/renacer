class Impuesto < ApplicationRecord
	def self.iva
		find(1)
	end 

	def self.iva_personal
		find(2)
	end 

end
