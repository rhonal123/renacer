class CarnetPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper
  include ContratosHelper
  include ApplicationHelper
  
  # 10 * 6.5
  def initialize(contratos)
    super(page_size: 'LETTER', margin: 10)
    @contratos = contratos
    w =  mm2pt(cm2mm(9))
    h = mm2pt(cm2mm(5.6))
    @contratos.each  do |contrato|
      move_down(20)
      bounding_box([0, cursor ], :width => w, :height => h ) do
        l2 = "#{Rails.root}/public/Logo02.jpg"
        image l2,:at => [150,h+10],:width => w-150, :height => h- 40
        _texto = """<b><i>SERVICIOS FUNERARIOS
        EL NUEVO RENACER C.A.</i></b>
        Teléfonos : 0251-415.83.86 /
        0416-124.30.84 / 0414-525.03.01  
        <b>RIF: J-40219124-3</b> """
        move_down(20)
        indent 12 do
          text _texto, :size => 10, :valign => :top, :indent=> 12, :inline_format => true
        end 
        move_down 10
        _text = "<b>CONTRATO N°: #{codigo_contrato(contrato.id)} </b>"
        text _text, :size => 10, :align=> :center, :inline_format => true
        move_down 10
       indent 12 do
          _text = "<b>Nombre :</b> #{contrato.cliente.nombres} #{contrato.cliente.apellidos}"
          text _text, :size => 10, :inline_format => true
          _text = "<b>C.I :</b> #{contrato.cliente.identidad} \t  <b>Plan:</b> #{contrato.plan.nombre} "
         text _text, :size => 10, :inline_format => true
          _text = "<b>Fecha Registro:</b> #{contrato.fecha_registro} "
          text _text, :size => 10, :inline_format => true
        end 
        stroke_bounds
      end
      bounding_box([ w + 10, cursor + h ], :width => w, :height => h) do
        l2 = "#{Rails.root}/public/Logo02.jpg"
        image l2,:at => [0,cursor],:width => w, :height => h
        tabla = [["Apellidos y Nombres","C.I."]]
        contrato.beneficiarios.each do |b|
         tabla << [b.nombre_corto,b.identidad]
        end 
        table(tabla,:header => true,
           :width => w   ,
           :cell_style => {size: 9, padding: 1},
           :position => :center)
        stroke_bounds
      end
    end 

=begin 
    define_grid(:columns => 2, :rows => 5, :gutter => 10)
    #grid.show_all

    l2 = "#{Rails.root}/public/Logo02.jpg"
    image l2, :at => [330,778],:width => 250, :height => 150
    
    image l2, :at => [10,770],:width => 50, :height => 70

    grid([0, 0], [0, 0]).bounding_box do
        bounding_box([60,147], :width => 231, :height => 75) do
          move_down(10)
          _texto = """<b><i>SERVICIOS FUNERARIOS
EL NUEVO RENACER C.A.</i></b>
Teléfonos: 0251-415.83.86 / 0416-124.30.84 
 0414-525.03.01 / 0426-657.31.59 
 RIF: J-40219124-3
          """
          text _texto, :size => 9, :align => :center , :valign => :top, :inline_format => true
          #stroke_bounds
        end 
        bounding_box([0,81], :width => 291, :height => 81) do
          move_down(20)
          _text = "CONTRATO N°: #{codigo_contrato(@contrato.id)} PLAN: #{@contrato.plan.nombre}"
          text _text, :size => 9, :align=> :center, :inline_format => true
          _text = " NOMBRE IDENTIDAD: #{@contrato.cliente.nombre_corto}"
          text _text, :size => 9, :align=> :center, :inline_format => true
          _text = "FECHA REGISTRO: #{@contrato.fecha_registro}"
          text _text, :size => 9, :align=> :center, :inline_format => true
          #stroke_bounds
        end 
        stroke_bounds
    end

    grid([0, 1], [0, 1]).bounding_box do
      stroke_bounds
      _texto = """<font size='11'><b><i>\nSERVICIOS FUNERARIOS EL NUEVO RENACER C.A.</i></b></font>"""
      text _texto, :align=> :center , :valign => :top, :inline_format => true
      titulo = ["BENEFICIARIO","IDENTIDAD"]
      pos = 15 
      @contrato.beneficiarios.each do |beneficiario| 
        bounding_box([0,pos], :width => 221, :height => 10) do
          _text = "#{beneficiario.nombre_corto}"
          text _text, :size => 8, :align=> :center,:valign => :center, :inline_format => true
          stroke_bounds
        end
        bounding_box([221,pos], :width =>70,:height => 10) do
          _text = "#{beneficiario.identidad}"
          text _text, :size => 8, :align=> :center , :valign => :center, :inline_format => true
          stroke_bounds
        end
        pos += 10 
      end
      
      bounding_box([0,pos], :width => 221, :height => 10) do
          _text = "<b><i>Beneficiario</b></i>"
          text _text, :size => 8, :align=> :center,:valign => :center, :inline_format => true
          stroke_bounds
      end
      bounding_box([221,pos], :width =>70,:height => 10) do
          _text = "<b><i>Identidad</b></i>"
          text _text, :size => 8, :align=> :center , :valign => :center, :inline_format => true
          stroke_bounds
      end

      #table(tabla,:header => true,
      #   :width => 280   ,
      #  #:column_widths  => [40,60,80,460,80],
      #   :cell_style => {size: 5, borders: [:bottom] },
      #   :position => :center)
    end

=end

    #bounding_box([0,600], :width => 280, :height => 200) do
    #  stroke_bounds
    #end

    #bounding_box([280,600], :width => 280, :height => 200) do
      #move_down(20)
      #text "Servicios Funerario Renacer", :align=> :center , :valign => :top
    #  l2 = "#{Rails.root}/public/Logo02.jpg"
    #  image l2 , :position =>0, :vposition => 0 , :width => 250, :height => 200
    #  stroke_bounds
    #  move_down(20)
    #  text "Servicios Funerario Renacer", :align=> :center , :valign => :top
    #end
  end

 end
