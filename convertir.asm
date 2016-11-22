section .text
 
; Funcion convertir: convierte el caracter en DL a hexa en ascii
; PARAMETROS:
; DL - Caracter
; RETORNO:
; DL - Caracter en hexa ascii
 
convertir:
 
  ;Resguardar la pila
  push EBP		;guardo el puntero a la base original
  mov EBP,ESP		;nuevo EBP apunta al tope

  cmp DL,9		;comparo con 9
  jg esletra		;si >9 es letra

esnumero:

  add DL,48		;si <=9 es numero, sumo 48
  jmp fin_convertir
  
esletra:

  add DL,55		;es letra: sumo 55
   
fin_convertir:

  ;Limpieza de la pila 	
  mov ESP, EBP      ;restauro el tope de la pila
  pop EBP       ;restauro la base de la pila 
  
  ret