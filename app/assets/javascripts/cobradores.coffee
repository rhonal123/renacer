# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/



class Cobradores
  planillaLiquidacion: () ->
    $('#formPlanillaLiquidacion #hasta').datepicker({
      autoclose: true,
      format: "dd/mm/yyyy",
      todayBtn: "linked",
      startView: 1,
      language: 'es'
    })  
    
    $('#formPlanillaLiquidacion #desde').datepicker({
      autoclose: true,
      format: "dd/mm/yyyy",
      todayBtn: "linked",
      startView: 1,
      language: 'es'
    })
  

@cobradores = new Cobradores  
  