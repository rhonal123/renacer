$(".formulario-facturacion").replaceWith("<%= escape_javascript(render('form', factura: @factura)) %>")

