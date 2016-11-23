section .text
 
; Funcion convertir: Convierte el caracter en DL a hexa en ascii (0..9A..F)
; PARAMETROS:
;   DL - Caracter
; RETORNO:
;   DL - Caracter en hexa ascii (0..9A..F)
 
convertir:

  cmp DL,9		;Comparo Caracter con 9
  jg esletra		;Si Caracter>9: Ir a esletra

esnumero:		;(Caracter<=9)

  add DL,48		;Caracter es numero. Sumo 48 para convertir a ascii numero (0..9)
  jmp fin_convertir	;Ir a fin
  
esletra:		;(Caracter>9)

  add DL,55		;Caracter es letra. Sumo 55 para convertir a ascii letra (A..F)
   
fin_convertir:
  
  ret			;Fin
