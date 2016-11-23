section .text
 
; Funcion caracter_imprimible: Dado un caracter en CL, si no es imprimible lo convierte a "."
; PARAMETROS:
;   CL - Caracter
; RETORNO:
;   CL - Caracter original si este es imprimible, "." si no era imprimible

caracter_imprimible:

  cmp CL, 31		;Comparo Caracter con 31
  jg imprimible		;Si (Caracter>31): Voy a imprimible
  
no_imprimible:		;Sino (Caracter<=31): Caracter no es imprimble

  mov CL, 46		;Entonces Caracter="."
  jmp fin_car_imprimible;Ir a fin

imprimible:

  cmp CL, 127		;Comparo Caracter con 127 ( 127 en ascii es DEL )
  je no_imprimible	;Si (Caracter=127): Ir a no_imprimible

fin_car_imprimible:

  ret			;Fin
