class CartulinaPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper
  include ContratosHelper
  include ApplicationHelper

  def initialize(contrato, _width = 453.5433 , _height = 555.2755)
    super(page_size: [_width,_height], margin: 10)
    font_size 10
    @height = _height
    @width = _width
    @contrato = contrato
    @rows = 20 
    @columns = 6 
    grid_cobrado
    start_new_page
    grid_pendiente
  end
  
 
  def grid_cobrado
    define_grid(:columns => @columns, :rows => @rows, :gutter => 0)
    #grid.show_all
    grid([0, 0], [0, 2]).bounding_box do
      _texto = "Nombres y Apellidos: #{@contrato.cliente.nombre_corto}"
      text _texto, :align=> :center , :valign => :center
      stroke_bounds
    end

    grid([0, 3], [0, 4]).bounding_box do
      text "Telefono: #{@contrato.cliente.telefono}", :align=> :center , :valign => :center
      stroke_bounds
    end

    grid([0, 5], [0, 5]).bounding_box do
      text "N°: #{codigo_contrato(@contrato.id)}", align: :center , valign: :center
      stroke_bounds
    end

    grid([1, 0], [1, 5]).bounding_box do
      text " Direccion: #{@contrato.cliente.direcion_corta}",size: 10, valign: :center
      stroke_bounds
    end

    grid([2, 0], [3, 1]).bounding_box do
      text " Cobrador : #{@contrato.cobrador.nombre} ", valign: :center
      stroke_bounds
    end
    semana = 52
    (1..9).each do |row|
      _r = row * 2 
      (0..5).each do |col|
        if _r > 2 or col > 1
          grid([_r, col ], [_r+1,col ]).bounding_box do
            move_down 5
            _texto = "semana #{semana}\n #{codigo_contrato(@contrato.id)}"
            text _texto, size: 9, :align => :center, valign: :top
            _texto = "#{moneda_venezuela(@contrato.plan.monto)}"
            text _texto   , size: 9, :align => :center, valign: :center
            _texto = "0416-124-30-84"
            text _texto , size: 9, :align => :center, valign: :bottom
            stroke_bounds
            semana -= 1
          end
        end
      end 
    end 
  end 

  def grid_pendiente
    define_grid(:columns => @columns, :rows => @rows, :gutter => 0)
    #grid.show_all
    grid([0,0], [0,5]).bounding_box do
      _texto = "Observaciones: "
      text _texto, :align=> :left, :valign => :center
      stroke_bounds
    end

    grid([1,0], [1,5]).bounding_box do
      stroke_bounds
    end

    grid([2,4], [3,5]).bounding_box do
      _texto = "#{@contrato.plan.nombre}"
      text _texto, :align=> :center, :valign => :center
      stroke_bounds
    end
    year = Time.now.year
    meses =(year)
    semana = 1
    (1..9).each do |row|
      _r = (10-row) * 2 
      (0..5).each do |col|
        if _r > 2 or col < 4 
          grid([_r, col ], [_r+1,col ]).bounding_box do
            move_down 4
            _texto = "#{meses[semana]}/#{year}"
            text _texto, size: 7, :align => :center, valign: :top
            _texto = "#{moneda_venezuela(@contrato.plan.monto * (53-semana)) } \nSERVICIOS\nFUNERARIO EL\nNUEVO RENACER C.A."
            text _texto   , size: 7, :align => :center, valign: :center
             stroke_bounds
            semana += 1
          end
        end
      end 
    end 
  end 

  def meses_semanas(year)
    meses = [ 
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
    lista = ["ENERO"]
    (1..12).each do |n|
      fecha = Date.new(year,n,1)
      fin = Date.new(year,n,fecha.last_day_of_month).strftime("%W").to_i 
      l = lista.size 
      (l..fin).each { lista << meses[n-1] }
    end 
    lista
  end 
end
