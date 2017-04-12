$("#mostrar_recibo_modal .modal-body").empty().append("<%= escape_javascript(render('show', recibo: @recibo)) %>")
$("#mostrar_recibo_modal").modal('show')