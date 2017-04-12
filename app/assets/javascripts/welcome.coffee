# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/






class Seleccionadores 

  capitalize = (cadena) -> 
    cadena.replace(/\b\w/g,(e) -> e.toUpperCase());

  _processResults = (data,params) -> 
    params.page = params.page || 1
    return {
      results: data.elements 
      pagination: {
        more: (params.page * 12) < data.total_entries
      }
    }
    
  _data =(params)->
      return {
         search: params.term,
         sort: "text"
         page: params.page
  }

  cliente: (element,data =_data,processResults =_processResults)-> 
    element = $("##{element}")
    formato = (obj)->
      if obj.text
        return obj.text 
      else 
        return capitalize("#{obj.nombres} #{obj.identidad}")

    element.off('select2:select')
    return element.select2(
      ajax:{
        url: "/clientes.json"
        type: "GET"
        dataType: "json"
        delay: 250,
        data: data
        processResults: processResults
        minimumInputLength: 10
      },
      placeholder: 'Seleccione una cliente ',
      escapeMarkup: (markup) -> markup
      minimumInputLength: 0,
      templateSelection: formato,
      templateResult: formato,
    )  


  clienteFiscal: (element,data =_data,processResults =_processResults)-> 
    element = $("##{element}")
    formato = (obj)->
      if obj.text
        return obj.text 
      else 
        return capitalize("#{obj.nombres} #{obj.identidad}")

    element.off('select2:select')
    return element.select2(
      ajax:{
        url: "/clientes_fiscales.json"
        type: "GET"
        dataType: "json"
        delay: 250,
        data: data
        processResults: processResults
        minimumInputLength: 10
      },
      placeholder: 'Seleccione una cliente fiscal ',
      escapeMarkup: (markup) -> markup
      minimumInputLength: 0,
      templateSelection: formato,
      templateResult: formato,
    )  

  plan: (element,data =_data,processResults =_processResults)-> 
    element = $("##{element}")
    formato = (obj)->
      if obj.text
        return obj.text 
      else 
        return capitalize("#{obj.nombre} #{obj.monto} bsf.")

    element.off('select2:select')
    return element.select2(
      ajax:{
        url: "/planes.json"
        type: "GET"
        dataType: "json"
        delay: 250,
        data: data
        processResults: processResults
        minimumInputLength: 10
      },
      placeholder: 'Seleccione una plan ',
      escapeMarkup: (markup) -> markup
      minimumInputLength: 0,
      templateSelection: formato,
      templateResult: formato,
    )  

@seleccionadores = new Seleccionadores





class MontosPago 
  grafico: (total_esperado,total_cobrado)->
    $(document).ready ->
      ctx = document.getElementById('myChart')
      myChart = new Chart(ctx,
        type: 'line'
        data:
          labels: ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31','32','33','34','35','36','37','38','39','40','41','42','43','44','45','46','47','48','49','50','51','52'] 
          datasets: [ {
            label: 'Total Esperado '
            data: total_esperado
            backgroundColor: 'rgba(0, 0, 0, 0)',
            borderColor: 'rgba(91, 192, 222, 1)'
          },
          {
            label: 'Total Cobrado'
            data: total_cobrado
            backgroundColor: 'rgba(0, 0, 0, 0)',
            borderColor: 'rgba(92, 184, 92, 1)'
          }])    
      return 
@montosPago = new MontosPago 
