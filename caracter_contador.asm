

section .text
 
; Funcion caracter_contador: convierte un numero en EAX a ascii hexa y lo guarda en 
; PARAMETROS:
; DL - Caracter
; RETORNO:
; DL - Caracter en hexa ascii

caracter_contador:
 
  ;Resguardar la pila
  push EBP		;guardo el puntero a la base original
  mov EBP,ESP		;nuevo EBP apunta al tope

 add EBX, 4
 
bucle_contador:
  
  mov EDX,0
  mov ECX, 16
  
  idiv ECX

  call convertir

  mov [EBX], DL

  dec EBX

  cmp EAX,0
  jne bucle_contador

  ;Limpieza de la pila 	
  mov ESP, EBP      ;restauro el tope de la pila
  pop EBP       ;restauro la base de la pila 
  
  ret