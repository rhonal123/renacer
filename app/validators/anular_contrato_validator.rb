class AnularContratoValidator < ActiveModel::Validator
  def validate record 
    record.errors.add :estado,
    	"El contrado debe estar creado para ser anulado." unless record.creado?
  end
end