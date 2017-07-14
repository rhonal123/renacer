class PagosProximoPeriodoValidator < ActiveModel::Validator
  def validate record
  	year = Date.today.year 
  	record.errors.add :estado, 
  			"No puedes generar pago de este año, dado que es el año entransito del contrato."  if year <= record.desde.year
  	record.errors.add :estado, "No puedes generar pagos a un contrato anulado o vencido" if record.anulado? or record.vencido?
  end
end