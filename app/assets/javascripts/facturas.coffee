# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class FormFactura

  constructor: (
    @productos = [],
    @current_page= null
    @per_page= null
    @total_entries= null
    @url= null ) ->

  inciarFormulario: (url,agregar,quitar) ->
    @url = url
    @urlAgregar = agregar
    @urlQuitar =  quitar
    @productos_factura =[]
    @current_page= null
    @per_page= null
    @total_entries= null
    select_cliente = seleccionadores.clienteFiscal("factura_cliente_fiscal_id")
    select_cliente.on('select2:select',(evt)->
      _cliente = evt.params.data
      $("#factura_direccion").val(_cliente.direccion) if _cliente.direccion?
      $("#factura_telefono").val(_cliente.telefono) if _cliente.telefono?
    );

  cargar_catalogo: (e, page = 1) -> 
    e.preventDefault()
    _self = this 
    url = _self.url_search(page)
    $.ajax(url,
      type: 'GET'
      dataType: 'json'
      success: (data, textStatus, jqXHR) ->
        _self.productos = data.productos
        _self.current_page  = data.current_page
        _self.per_page  = data.per_page
        _self.total_entries  = data.total_entries
        _self.dibujar_productos()
        _self.dibujar_paginador()
      error: (jqXHR,textStatus,errorThrown) -> 
        alert "error"
    )

  dibujar_paginador: ()->
    _self = this 
    paginador = $("#catalogo_productos #paginador")
    nav = $("<nav>")
    ul = $("<ul>", class: "pagination")
    total_page = (@total_entries / @per_page )
    i = 0
    while(i <total_page)
      params = { }
      if((i + 1) == @current_page)
        params.class= "active"
      li = $("<li>",params)
      page = new Number(i+1) 
      params = { 
        "data-page": (i + 1) 
      }
      a  = $("<a>",params).append(page).click(
        (e)-> 
          page = new Number($(e.target).data('page')) 
          _self.cargar_catalogo(e,page)
      )
      li.append(a)
      ul.append(li)
      i++ 
    nav.append(ul)
    paginador.empty().append(ul)

  url_search: (page)->
    datos= {
      search: $("#search").val(),
      page: page,
      sort: "descripcion"
    }
    return @url+"?"+decodeURIComponent($.param(datos))

  dibujar_productos: ( )->
    _self = this 
    catalago = $("#catalogo_productos #productos").empty()
    for v in @productos  
      producto_id = $("<td>").append(v.id)
      descripcion = $("<td>").append(v.descripcion)
      precio = $("<td>").append(Format.Money(v.precio)) 
      agregar = $("<button>",{
          class: "btn btn-sm btn-defaul"
          id: v.id
        }).append("agregar").click(
          (e)->
            e = $(e.target)
            for item in _self.productos
              if(item.id.toString() == e.attr('id')) 
                _self.agregar(item)
        )
      tr = $("<tr>").append(producto_id,descripcion,precio,$("<td>").append(agregar))
      catalago.append(tr)
    $("#catalogo_productos").modal('show')

  agregar: (item)->
    form = $("#new_factura")
    url = "#{@urlAgregar}?#{decodeURIComponent($.param(producto_id: item.id))}"
    data = form.serialize()
    $.ajax(url,
      type: 'POST'
      data: data 
      dataType: 'script')
    $("#catalogo_productos").modal('hide')

  calcularMontos: ()->
    sum = 0.0
    $('#productos').find('.producto').each (i,v)->
      item = $(v)
      cantidad = parseFloat(item.find('.cantidad').val())  
      if isNaN(cantidad)
        cantidad = 0 
      precio = parseFloat(item.find('.cantidad').data('precio'))
      total = cantidad * precio; 
      sum += total 
      item.find(".total").empty().append(Format.Money(total))
    impuesto = $("#new_factura").data('impuesto')

    $('#plan_base').empty().append(Format.Money(sum))
    $('#plan_iva').empty().append(Format.Money(impuesto * sum ))
    $('#plan_total').empty().append(Format.Money(sum + impuesto * sum))

  quitarProducto: (producto)->
    $('#productos').find("##{producto}").remove()
    @calcularMontos()
    return 

@formFactura = new FormFactura  


class FormRecibo
  constructor: (@url= null) ->

  inciarFormulario: (url) ->
    @url = url
    $('.fecha').datepicker({
      autoclose: true,
      format: "dd/mm/yyyy",
      todayBtn: "linked",
      startView: 1,
      language: 'es'
    })
    
  agregar: (event)->
    form = $("#new_recibo")
    url = @url
    data = form.serialize()
    $.ajax(url,
      type: 'POST'
      data: data 
      dataType: 'script')

  calcularMontos: ()->
    sum = 0.0
    productos = $('#pagos').find('.monto')
    productos.each (i,v)->
      item = $(v)
      monto = parseFloat($(v).val())
      if isNaN(monto)
        monto = 0 
      sum += monto
    $("#monto").empty().append(Format.Money(sum.toFixed(2)))

  quitar: (event)->
    e = $(event.target)
    e.parent().parent().remove()

@formRecibo = new FormRecibo  
