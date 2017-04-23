namespace :cobrador do
  desc "Generar cobradores desde cobrador_old y asignarlo a un contrato "
  task generar_cobradores: :environment do
		cobradores_old = Contrato.uniq(:cobrador_old).pluck(:cobrador_old)
		cobradores_old.each_with_index do |cobrador_old,index|
			cobrador = Cobrador.create(identidad: "V-000000#{index}",nombre: cobrador_old)
			if cobrador.created_at?
				Contrato.where(cobrador_old: cobrador_old).update_all(cobrador_id: cobrador.id)				
			end 
		end 
  end
end
