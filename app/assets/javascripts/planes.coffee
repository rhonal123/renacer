# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class FormPlan
  calcularMontoPlan: () ->
    semanal = $('#plan_monto').val()
    mensual = $('#mensual').empty().append(this.format(semanal * 4))
    semestral = $('#semestral').empty().append(this.format(semanal * 26))
    anual = $('#anual').empty().append(this.format(semanal * 52))
  format: (c) -> 
   return "$" + c.toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,');


@formPlan = new FormPlan  


