section .text
 
; Funcion itoa: convierte un entero a string
; PARAMETROS:
;  EAX - Entero
; EBX - Puntero a char (string)
; RETORNO:
; EBX - Cantidad de caracteres del string
 
itoa:
 
  ;Resguardar la pila
  push EBP      ;guardo el puntero a la base original
  mov EBP,ESP       ;nuevo EBP apunta al tope
 
  push 0xa      ;Guardo un entero de valor 10
            ;Este entero está en la direccion EBP-4
 
  push EBX      ;Guardo una copia del puntero al string
 
  ;EAX tiene el entero a convertir y EBX el puntero al buffer
 
  mov ECX,0     ;inicializo el contador de caracteres
 
itoa_dividir:
 
  mov EDX,0     ;inicializo EDX en 0 para dividir
  idiv DWORD[EBP-4] ;dividi el entero por 10
 
  ;Ahora EAX tiene el cociente y EDX el modulo
 
  ;Convierto el digito decimal a ascii
 
  add EDX,48        ;sumo 48 al digito
 
  push EDX      ;guardo el char en la pila
 
  inc ECX       ;incremento el contador de caracteres
 
  cmp EAX,0     ;EAX == 0?
  jnz  itoa_dividir ;paso al siguiente digito
 
  ;Ahora ECX tiene la cantidad de caracteres apilados (en orden reverso)
  ;EBX sigue apuntando al buffer
 
  mov EAX,ECX       ;guardo la cantidad de caracteres para retornar
 
itoa_guardar:
 
  pop EDX       ;desapilo el siguiente caracter
  mov [EBX],DL      ;guardo el char en el buffer
  inc EBX       ;avanzo al siguiente char
  dec ECX       ;decremento el contador
  cmp ECX,0        ;contador == 0?
  jnz itoa_guardar  ;desapilo el siguiente
 
  ;Ahora en el buffer esta el string representado
  ;En EAX esta la cantidad de digitos (char)
 
  ;Limpieza de la pila
 
  pop EBX       ;Recupero el valor de EBX
 
  mov ESP, EBP      ;restauro el tope de la pila
  pop EBP       ;restauro la base de la pila
 
 ret
