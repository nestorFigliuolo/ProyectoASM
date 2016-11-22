section .text
 
; Funcion caracter_contador: convierte un numero (menor a 2^20) en EAX a ascii hexa y lo guarda en 
; los primeros 5 lugares del buffer de EBX
; PARAMETROS:
; EAX - Numero
; EBX - Buffer 
; RETORNO:
; EBX - Con sus primeros 5 lugares representando al numero en hexa ascii

caracter_contador:

  add EBX, 4		;Sumo 4 a buffer, empiezo desde la posicion menos significativa
 
bucle_contador:
  
  mov EDX,0		;Preparo EDX=0 para usar idiv
  mov ECX,16		;ECX=16 divisor
  idiv ECX		;Divido por 16, EDX=resto, EAX=cociente
    
  call convertir	;Convierto 0<resto<16 en ascii hexa
  mov [EBX], DL		;Muevo ascii hexa a buffer
  dec EBX		:Decremento buffer. Muevo una posicion a la izquierda
  
  cmp EAX,0		;Comparo Cociente con 0.
  jne bucle_contador	;Si (Cociente!=0): sigo dividiendo
  
  ret			;Si (Cociente=0): Fin