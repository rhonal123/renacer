class FacturaPdf < Prawn::Document

  def initialize(factura)
  	super(page_size: "LETTER", margin: 10)
    font_size 12

  end

end
