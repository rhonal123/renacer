class ActivarContratoValidator < ActiveModel::Validator
  def validate record
		record.errors.add :estado, 
			"No Puedes Activar este Contrato. se encuenta #{record.estado}" unless record.creado? or record.inactivo?
  end
end