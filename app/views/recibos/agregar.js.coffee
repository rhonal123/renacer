$(".formulario-recibo").replaceWith("<%= escape_javascript(render('form',recibo: @recibo, factura: @factura)) %>")

