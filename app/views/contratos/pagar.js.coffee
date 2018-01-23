
$(".pagosContrato").replaceWith "<%= escape_javascript(render('pagos', contrato: @pago.contrato, pago: @pago, ano: @pago.ano, activeClass: "active")) %>"

alert "<%= @response ? "Pago Procesado " : "error al procesar pago #{@pago.errors.full_messages.join(',')}" %>"
