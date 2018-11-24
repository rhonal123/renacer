class CartulinaAnoPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper
  include ContratosHelper
  include ApplicationHelper

  def initialize(contrato, _width = 453.5433 , _height = 555.2755)
    super(page_size: [_width,_height/2], margin: 10)
    font_size 10
    @height = _height/2
    @width = _width
    @contrato = contrato
    @rows = 20 
    @columns = 8 
    @meses = [ 
      "ENERO",
      "FEBRERO",
      "MARZO",
      "ABRIL",
      "MAYO",
      "JUNIO",
      "JULIO",
      "AGOSTO",
      "SEPTIEMBRE",
      "OCTUBRE",
      "NOVIEMBRE",
      "DICIMEBRE"
    ]

    grid_cobrado
    start_new_page
    grid_pendiente
  end
  
 
  def grid_cobrado
    define_grid(:columns => @columns, :rows => @rows, :gutter => 0)
    #grid.show_all
    grid([0, 0], [2, 3]).bounding_box do
      _texto = "NOMBRES Y APELLIDOS: #{@contrato.cliente.nombre_corto}"
      text _texto, :align=> :center , :valign => :center
      stroke_bounds
    end

    grid([0, 4], [2, 5]).bounding_box do
      text "TELEFONO: #{@contrato.cliente.telefono}", :align=> :center , :valign => :center
      stroke_bounds
    end

    grid([0, 6], [2, 7]).bounding_box do
      text "N°: #{codigo_contrato(@contrato.id)}", align: :center , valign: :center
      stroke_bounds
    end

    grid([3, 0], [5, 7]).bounding_box do
      text " DIRECCION: #{@contrato.cliente.direcion_corta}",size: 10, valign: :center
      stroke_bounds
    end

    grid([6, 0], [7, 7]).bounding_box do
      text " COBRADOR: #{@contrato.cobrador.nombre} ", valign: :center
      stroke_bounds
    end
    semana = 0
    (0..2).each do |row|
      _r = (row * 4 ) + 8
      (0..3).each do |col|
        col = col * 2
        puts " [ #{_r}, #{col} ], [#{_r + 3 } ,#{col + 1 } ] "  
        #if _r > 2 or col > 1
          grid([_r, col ], [_r  + 3 ,col + 1 ]).bounding_box do
            move_down 5
            _texto = "#{@meses[semana]}\n #{codigo_contrato(@contrato.id)}"
            text _texto, size: 9, :align => :center, valign: :top
            _texto = "#{moneda_venezuela(@contrato.plan.monto * (12-semana)  )}"
            text _texto   , size: 9, :align => :center, valign: :center
            _texto = Configuracion.first.telefono
            text _texto , size: 9, :align => :center, valign: :bottom
            stroke_bounds
            semana += 1
          end
        #end
      end 
    end 
  end 

  def grid_pendiente
    define_grid(:columns => @columns, :rows => @rows, :gutter => 0)
    #grid.show_all
    grid([0,0], [2,7]).bounding_box do
      _texto = "OBSERVACIONES: "
      text _texto, :align=> :left, :valign => :center
      stroke_bounds
    end

    grid([3,0], [5,7]).bounding_box do
      stroke_bounds
    end

    grid([6,4], [7,7]).bounding_box do
      _texto = "#{@contrato.plan.nombre}"
      text _texto, :align=> :center, :valign => :center
      stroke_bounds
    end
    year = Time.now.year
    meses =(year)
    semana = 1

    (0..2).each do |row|
      _r = (row * 4 ) + 8
      (0..3).each do |col|
        col = col * 2
        puts " [ #{_r}, #{col} ], [#{_r + 3 } ,#{col + 1 } ] "  
        #if _r > 2 or col > 1
          grid([_r, col ], [_r  + 3 ,col + 1 ]).bounding_box do
            move_down 4
            _texto = "#{meses[semana]}/#{year}"
            text _texto, size: 7, :align => :center, valign: :top
            _texto = "#{moneda_venezuela(@contrato.plan.monto * (53-semana)) } \nSERVICIOS\nFUNERARIO EL\nNUEVO RENACER C.A."
            text _texto   , size: 7, :align => :center, valign: :center
             stroke_bounds
            semana += 1
          end
        #end
      end 
    end 
  end 
end
