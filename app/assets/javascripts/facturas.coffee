# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class FormFactura

  constructor: (
    @productos = [],
    @current_page= null
    @per_page= null
    @total_entries= null
    @url= null
    @nroDetalle = 0 ) -> 

  inciarFormulario: () ->
    select_cliente = seleccionadores.clienteFiscal("factura_cliente_fiscal_id")
    select_cliente.on('select2:select',(evt)->
      _cliente = evt.params.data
      $("#factura_direccion").val(_cliente.direccion) if _cliente.direccion?
      $("#factura_telefono").val(_cliente.telefono) if _cliente.telefono?
    );
    @table = $('#tablaP').DataTable({
      processing: true,
      serverSide: true,
      pageLength: 35,    
      dom: 'Bfrtip',
      ajax: {
        url: '/facturas/productos',
        dataSrc: 'productos'
      },
      columns: [{data: 'id'},{data: 'descripcion'},{data: 'precio',render: $.fn.dataTable.render.number( ',', '.', 2)}],
      select: {
        style:     '',
        className: 'active'
      }
    });

  cargar_catalogo: (e) -> 
    e.preventDefault()
    $("#catalogo_productos").modal('show')

  agregar: ()->
   datos =  @table.rows({selected: true}).data()
   productos = $('#productos').find('.producto')
   _this = this 
   $.each datos, (index,item) ->
    if $('#productos').find("tr##{item.id}").length == 0
      tr = $("<tr></tr>",{id: item.id})
      tdid = $("<td>#{item.id}</td>")
      hidden = $("<input></input>",{
        value: item.id,
        name: "factura[detalles_attributes][#{_this.nroDetalle}][producto_id]",
        type: "hidden"
      })
      tdid.append hidden 
      tdprodcuto = $("<td>#{item.descripcion}</td>")
      tdmonto = $("<td>#{Format.Money(item.precio)}</td>")
      tdcantidad = $("<td></td>")
      cantidad =  $("<input></input>",{
        class: "cantidad",
        onkeyup: "formFactura.calcularMontos()",
        onchange: "formFactura.calcularMontos()",
        type: "number",
        name: "factura[detalles_attributes][#{_this.nroDetalle}][cantidad]",
        data: {
          precio:  item.precio
        }
      })
      tdcantidad.append cantidad
      tdtotal = $("<td></td>",{class: "total"})
      tdtotal.append "0.00"
      tdquitar =  $("<td></td>")
      button = $("<button></button>",{
        class:   "btn btn-danger btn-sm",
        type: "button",
        onClick: "formFactura.quitarProducto(#{item.id})"
      })
      button.append "quitar"
      tdquitar.append button
      tr.append tdid
      tr.append tdprodcuto
      tr.append tdmonto
      tr.append tdcantidad
      tr.append tdtotal   
      tr.append tdquitar 
      $('#productos').append tr
      _this.nroDetalle++;

  calcularMontos: ()->
    id = parseInt($("#factura_impuesto_id").val())
    sum = 0.0
    $('#productos').find('tr').each (i,v)->
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
    if id != 2
      $('#plan_iva').empty().append(Format.Money(impuesto * sum ))
      $('#plan_total').empty().append(Format.Money(sum + impuesto * sum))
    else 
      monto = parseFloat($('#factura_monto_impuesto').val())
      $('#plan_total').empty().append(Format.Money(sum + monto))

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
