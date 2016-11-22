

section .text
 
; Funcion convertir: ;convierte CL a un caracter imprimible
; PARAMETROS:
; CL - Caracter
; RETORNO:
; CL - Caracter imprimible o "." si caracter no es imprimible

caracter_imprimible:

  ;Resguardar la pila
  push EBP		;guardo el puntero a la base original
  mov EBP,ESP		;nuevo EBP apunta al tope

  cmp CL, 31		;CL>31?
  jg imprimible		;si >31: ir a imprimible
  
no_imprimible:		;sino: no imprimible

  mov CL, 46		;no imprimible: CL="."
  jmp fin_car_imprimible

imprimible:

  cmp CL, 127		;CL=127? | 127 es DEL
  je no_imprimible	;si =127 ir a no imprimible

fin_car_imprimible:

  ;Limpieza de la pila 	
  mov ESP, EBP      ;restauro el tope de la pila
  pop EBP       ;restauro la base de la pila 
  
  ret
