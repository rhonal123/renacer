

# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


class FormContrato
  _plan = null

  inciarFormularioCambiarPropietario: ()->
    seleccionadores.cliente("contrato_cliente_id")

    
  inciarFormulario: (_planJson = null) ->
    _plan = _planJson
    _this = this
    $('form #contrato_desde').datepicker({
      autoclose: true,
      format: "dd/mm/yyyy",
      todayBtn: "linked",
      startView: 1,
      language: 'es'
    }).on('changeDate', (ev) -> 
      _this.pagos()
    );

    $('form #contrato_fecha_registro').datepicker({
      autoclose: true,
      format: "dd/mm/yyyy",
      todayBtn: "linked",
      startView: 1,
      language: 'es'
    })

    $('form #contrato_hasta').datepicker({
      autoclose: true,
      format: "dd/mm/yyyy",
      todayBtn: "linked",
      startView: 1,
      language: 'es'
    }).on('changeDate', (ev) -> 
      _this.pagos()
    );

    seleccionadores.cliente("contrato_cliente_id")
    plan = seleccionadores.plan("contrato_plan_id")
    plan.on('select2:select',(evt)->
      _plan = evt.params.data
      _this.pagos()
      $("#plan_monto").append _plan.monto 
      $("#plan_mensual").append _plan.monto *4 
      $("#plan_semestral").append _plan.monto * 26
      $("#plan_anual").append _plan.monto * 52
      $("#plan_componentes").append _plan.componentes
    );
    this.pagos()

  pagos: () -> 
    desde = moment($('form #contrato_desde').val(),"DD/MM/YYYY")

    year = moment(new Date()).year()
    hasta = moment( new Date(year,11,31)) 
    if(desde >= hasta)
      aler "La Fecha es Invalida ";
    else
      desdeweek = desde.week()
      hastaweek = hasta.week()
      if(hastaweek == 1) 
        hastaweek = 52  
      if(desdeweek >= hastaweek)
        desdeweek = 1
      pagos = []
      i = desdeweek
      while i <= hastaweek 
        pagos.push i
        i++
      console.log "dibujar"
      this.dibujarPagos(pagos)
    return 

  dibujarPagos: (pagos) -> 
    if _plan
      total = 0
      $('#listadoPago').empty()
      j = 1
      for i in pagos
        pago = $("<li></li>",{class:"list-group-item"});
        monto = $("<span></span>",{class:"badge"})
        total += _plan.monto
        monto.append("#{j*_plan.monto} Bs.")
        pago.append(monto);
        pago.append("Semana N° #{i}");
        $('#listadoPago').append(pago)
        j++

      $('#total').empty().append("Total :#{total} Bs.")

@formContrato = new FormContrato  


class Contrato
  generarReporte: () ->
    $('#formGenerarReporte #hasta').datepicker({
      autoclose: true,
      format: "dd/mm/yyyy",
      todayBtn: "linked",
      startView: 1,
      language: 'es'
    })  
    
    $('#formGenerarReporte #desde').datepicker({
      autoclose: true,
      format: "dd/mm/yyyy",
      todayBtn: "linked",
      startView: 1,
      language: 'es'
    })

    $('#formGenerarReporte').submit (e)->
      e.preventDefault();
      desde = $('#formGenerarReporte #desde').val()
      hasta = $('#formGenerarReporte #hasta').val()
      url = $(this).attr('action')
      url = "#{url}?desde=#{desde}&hasta=#{hasta}"
      window.open(url, '_blank').focus()

@contratos = new Contrato  
  

