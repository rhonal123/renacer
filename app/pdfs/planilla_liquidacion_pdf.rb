class PlanillaLiquidacionPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper
  include ContratosHelper
  include ApplicationHelper

  def initialize(parametros)
    super(margin: 10, page_layout: :landscape)
    font_size 10
		@desde  = parametros[:desde]
		@hasta = parametros[:hasta]
		@cobrador = Cobrador.find(parametros[:cobrador_id])
    @planes = Plan.all 
    define_grid(:columns => 10, :rows => 20, :gutter => 0)
		encabezado 
  end

  def encabezado 
    l1 = "#{Rails.root}/public/Logo02.jpg"
    image l1, :at => [20,610],:width => 200, :height => 140

	  grid([0,2], [2, 7]).bounding_box do
      _texto = """<font size='14'><b><i>SERVICIOS FUNERARIOS
					EL NUEVO RENACER C.A.</i></b></font>
					Carrera 33 con Av. Andres Bello entre Calle 21. Edif 
					Sindicato de Hospitales y Clinica, Local 1, PB. Barquisimeto.
					0251-415.83.86 / 0416-124.30.84 / 0414-525.03.01 / 0426- 
					657.31.59  /0251-231.38.86/  
					<b><i>Rif J-40219124-3</i></b>"""
      text _texto, :align=> :center , :valign => :center, :inline_format => true
    end

	  grid([4,3], [4,6]).bounding_box do
      _texto = """HOJA DE LIQUIDACION COBRADOR #{@desde} -- #{@hasta}"""
      text _texto, :align=> :center , :valign => :center, :inline_format => true
    end


	  grid([5,7], [6,9]).bounding_box do
      _texto = """
				FECHA  : #{Date.today} 
				ZONA :                       
				COBRADOR : #{@cobrador.nombre}
      """
      text _texto, :align=> :center , :valign => :center, :inline_format => true
    end

	 grid([7,0], [19,9]).bounding_box do
      titulo = ["PLAN","CONTRATOS","MONTO BS","CANCELADO","COBRADO BS","30%","PRENSA","TOTAL"]
			tabla = []
			tabla << titulo 
			@planes.each do |plan|
				totalizar_pagos = @cobrador.totalizar_pagos(plan.id,@desde,@hasta)
				nro_cancelado = totalizar_pagos.first.first
				total_cobrado = totalizar_pagos.first.second
				pendiente = @cobrador.pendiente_por_cobrar(plan.id)
				arr = []
				arr << plan.nombre
				arr << @cobrador.contratos.where(plan_id: plan.id).count
				arr << moneda_venezuela(@cobrador.contratos.where(plan_id: plan.id).sum(:total) )
				arr << nro_cancelado 
				arr << moneda_venezuela(total_cobrado.to_f)
				arr << moneda_venezuela(total_cobrado.to_f * 0.30 )
				arr << ""
				arr << moneda_venezuela(pendiente.to_f)
				tabla << arr
			end  

			table tabla,:header => true,
				 :width => 750,
				 #:column_widths	=> [40,60,80,460,80],
				 #:cell_style => {size: letra_sm-3},
				 :position => :center 
    end
  end 
end
