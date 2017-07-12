class CambiarPlanContratoValidator < ActiveModel::Validator
  def validate record
    record.errors.add :estado,"No Puedes Cambiar el Plan,este Contrato. se encuenta #{record.estado}" if record.anulado? or record.vencido?
  end
end
