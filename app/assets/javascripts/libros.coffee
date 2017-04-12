# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


class FormLibro
  actualizarLibro: (url)->
    datos= {
      mes: $("#libro_mes").val(),
      ano: $("#libro_ano").val(),
      declarado: $("#libro_declarado").checked
    }
    url = url+"?"+decodeURIComponent($.param(datos))
    Turbolinks.visit(url)
@formLibro = new FormLibro  
