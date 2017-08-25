class AnularFacturaValidator < ActiveModel::Validator
  def validate record 
  	unless record.anulable?
	    record.errors.add :estado,
	    	"No Puedes Anular esta Factura se encuenta #{record.estado}" if record.pendiente?

	    record.errors.add :estado,
	    	"No Puedes Anular esta Factura pertenece al libro del mes #{record.libro.mes}" unless record.libro.nil?
  	end
  end
end