module CobradoresHelper
	def contratos_cobrador cobrador 
		contratos = cobrador.contratos.joins(:cliente).pluck(:id,:estado,Cliente.arel_table[:nombres],Cliente.arel_table[:apellidos])
		render('cobradores/contratos', cobrador: cobrador,contratos: contratos )
	end 
end