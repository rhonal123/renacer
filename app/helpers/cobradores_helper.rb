module CobradoresHelper
	def contratos_cobrador cobrador 
		contratos = cobrador.
			contratos.
			joins(:cliente,:plan).
			order(Plan.arel_table[:nombre]).
			pluck(:id,:estado,Cliente.arel_table[:nombres],Cliente.arel_table[:apellidos],Plan.arel_table[:nombre])
		render('cobradores/contratos', cobrador: cobrador,contratos: contratos )
	end

	def monto_cobrado_diario cobrador, fecha 
		return moneda_venezuela(@cobrador.pagos.where(fecha_pago: @fecha).sum(:monto))
	end 

	def monto_cobrado_diario_30 cobrador, fecha
		return moneda_venezuela(@cobrador.pagos.where(fecha_pago: @fecha).sum(:monto) * 0.30 )
	end 

	def seleccionar_fecha_cobrador(cobrador, fecha)
		elementos = []  	
    elementos.append text_field_tag(:fecha,fecha, id: "fecha", class: "form-control")
	  form_tag(cobrador_pagar_path(cobrador.id),id: 'cagar_fecha_cobrador', method: "get", class: "form-group pull-right") do |f| 
      elementos.join.html_safe
    end 
  end 

  def seleccionar_pagos_por_ano_cobradorees cobrador,contrato,fecha, ano 
    elementos = [];
    inicio = (contrato.fecha_registro.nil? ? Date.today.year : contrato.fecha_registro.year )
    _fecha = Date.today.year 
    elementos.append hidden_field_tag(:fecha,fecha)
    elementos.append select_tag("ano", options_for_select(inicio.._fecha,ano),
        class: "form-control",
        onchange: "$('#cargar_pagos_contratos').submit();",        
        data: {  
        url:  contrato_pagos_path(contrato),    
      })

    form_tag(cobrador_seleccionar_contrato_path(cobrador.id,contrato.id),id: 'cargar_pagos_contratos', method: "get" ) do |f| 
      elementos.join.html_safe
    end 
  end 


end