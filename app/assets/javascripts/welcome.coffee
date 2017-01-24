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