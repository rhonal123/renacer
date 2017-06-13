module ContratosHelper

  def seleccionar_pagos_por_ano contrato,ano
    inicio = (contrato.fecha_registro.nil? ? Date.today.year : contrato.fecha_registro.year )
    fecha = Date.today.year 
    select_tag("year", options_for_select(inicio..fecha,ano),
        data: {remote: true, 
        url:  contrato_pagos_path(contrato) 
    })
  end 

	def codigo_contrato(id)
		s = "000000#{id}" 
		s[s.size-6, s.size]
	end 

  def cm2mm(cm)
    return cm * 10
  end

  def dm2mm(dm)
    return dm * 100
  end

  def m2mm(m)
    return m * 1000
  end

  # imperial conversions
  # from http://en.wikipedia.org/wiki/Imperial_units
  def ft2in(ft)
    return ft * 12
  end

  def yd2in(yd)
    return yd * 36
  end

  # PostscriptPoint-converisons
  def pt2pt(pt)
    return pt
  end

  def in2pt(inch)
    return inch * 72
  end

  def ft2pt(ft)
    return in2pt(ft2in(ft))
  end

  def yd2pt(yd)
    return in2pt(yd2in(yd))
  end

  def mm2pt(mm)
    return mm * (72 / 25.4)
  end

  def cm2pt(cm)
    return mm2pt(cm2mm(cm))
  end

  def dm2pt(dm)
    return mm2pt(dm2mm(dm))
  end

  def m2pt(m)
    return mm2pt(m2mm(m))
  end

  def pt2mm(pt)
    return pt * 1 / mm2pt(1) # (25.4 / 72)
  end
end
