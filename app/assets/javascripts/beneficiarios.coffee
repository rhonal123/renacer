
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class FormBeneficiario

  @modal = null

  inciarFormulario: (form = null) ->
    @modal = $('#beneficiarioModal')
    @modal.find(".contenido").empty().append(form)
    @modal.modal()  

  agregarBeneficiario: (beneficiario = null) ->
    $("#beneficiario").find(".listaBeneficiarios").append(beneficiario)
    @modal.modal('hide')

  quitarBeneficiario: (id) ->
    elemento = $("#beneficiario").find(".listaBeneficiarios").find("#"+id)
    elemento.remove()

  editarBeneficiario: (contenido, id ) -> 
    elemento = $("#beneficiario").find(".listaBeneficiarios").find("#"+id)
    elemento.replaceWith(contenido)
    @modal.modal('hide')

@formBeneficiario = new FormBeneficiario  


