section .text
 
; Funcion convertir: convierte el caracter en CL a hexa en ascii. Los caracteres hexa
; se almacenan en CH y CL EN ORDEN INVERTIDO.
; Para que los caracteres se copien en el orden correcto se debe usar CX.
; PARAMETROS:
; CL - Caracter
; RETORNO:
; CL - Primer hexa en ascii
; CH - Segundo hexa en ascii
 
caracter_hexa:
 
  ;Resguardar la pila
  push EBP		;guardo el puntero a la base original
  mov EBP,ESP		;nuevo EBP apunta al tope
 
  mov DL,CL		;copio caracter
  and DL,00001111b	;obtengo ultimos 4 bits
  
  call convertir
  
  mov CH,DL		;copio ultimo hexa a CH. ORDEN INVERTIDO
  mov DL,CL		;copio caracter
  shr DL,4		;obtengo primeros 4 bits
  
  call convertir

  mov CL,DL		;copio primer hexa a CL. ORDEN INVERTIDO
  
  ;Limpieza de la pila 	
  mov ESP, EBP      ;restauro el tope de la pila
  pop EBP       ;restauro la base de la pila 
  
  ret