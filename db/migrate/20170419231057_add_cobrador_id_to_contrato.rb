class AddCobradorIdToContrato < ActiveRecord::Migration[5.0]
  def change
  	rename_column :contratos, :cobrador, :cobrador_old
    add_reference :contratos, :cobrador, foreign_key: true
    execute <<-SQL
    	update contratos set cobrador_old = 'NO-DEFINE' where cobrador_old is null or LENGTH(trim(cobrador_old))  = 0
    SQL
		
		cobradores_old = Contrato.uniq(:cobrador_old).pluck(:cobrador_old)
		cobradores_old.each_with_index do |cobrador_old,index|
			cobrador = Cobrador.create(identidad: "V-000000#{index}",nombre: cobrador_old)
			if cobrador.created_at?
				Contrato.where(cobrador_old: cobrador_old).update_all(cobrador_id: cobrador.id)				
			end 
		end 
		
  end
end
