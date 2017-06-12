module CobradoresHelper
	def contratos_cobrador cobrador 
		contratos = cobrador.
			contratos.
			joins(:cliente,:plan).
			order(Plan.arel_table[:nombre]).
			pluck(:id,:estado,Cliente.arel_table[:nombres],Cliente.arel_table[:apellidos],Plan.arel_table[:nombre])
		render('cobradores/contratos', cobrador: cobrador,contratos: contratos )
	end 
end