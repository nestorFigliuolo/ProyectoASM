section .text
 
; Funcion caracter_hexa: Convierte el caracter en CL a hexa ascii. Los caracteres hexa
; se almacenan en CH y CL EN ORDEN INVERTIDO.
; Para que los caracteres se impriman en el orden correcto se debe usar CX.
; PARAMETROS:
; CL - Caracter
; RETORNO:
; CL - Primer hexa en ascii. 
; CH - Segundo hexa en ascii. 
 
caracter_hexa:

  mov DL,CL		;Hago copia de caracter
  and DL,00001111b	;Obtengo ultimos 4 bits
  
  call convertir	;Convierto 4 bits a hexa ascii (0..9A..F)
  
  mov CH,DL		;Copio segundo hexa en CH. (ORDEN INVERTIDO)
  mov DL,CL		;Hago copia de caracter
  shr DL,4		;Obtengo primeros 4 bits
  
  call convertir	;Convierto 4 bits a hexa ascii (0..9A..F)

  mov CL,DL		;Copio primer hexa en CL. (ORDEN INVERTIDO)
  ret			;Fin