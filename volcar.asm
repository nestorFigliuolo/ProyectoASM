%include "convertir.asm"
%include "itoa.asm"
%include "caracter_hexa.asm"
%include "caracter_imprimible.asm"
%include "caracter_contador.asm"


%define hex_offset 7
%define char_offset 57
%define linea_max 16

section .data

  ayuda db "Ayuda"
  ayudal equ $ - ayuda
  linea db "00000  hh hh hh hh hh hh hh hh hh hh hh hh hh hh hh hh  |................|"
  lineal equ $ - linea
  buffer0s db "00000"
  buffer0sl equ $ - buffer0s

  contador dd 0 			;contador de lineas
  hex_pos dd hex_offset			;offset a la posicion de la linea para insertar la representacion hexadecim
  char_pos dd char_offset		;offset a la posicion de la linea donde insertar el char


  salto db 10
  espacio db 0x20
  barra db 7ch
resto dd 0


section .bss

  buffer: resb 1048576		;Buffer para leer de archivo
  buf: resb 32

section .text

global _start

imprimir_salto:

; imprimo un salto de linea por pantalla
mov EAX,4
mov EBX,1
mov ECX,salto
mov EDX,1
int 80h
ret

imprimir_itoa:

mov EBX,buf
call itoa

mov EAX,4
mov EBX,1
mov ECX,buf
mov EDX,32
int 80h

call imprimir_salto

ret

_start:

;Miro la cantidad de parametros

pop EAX				;saco la cantidad de parametros
cmp EAX, 2			;argc == 2?
jne salir_error			;si no es 2 salgo con error


;Miro los argumentos

pop EAX				;Descarto el nombre del programa
pop EAX				;Guardo el puntero al segundo parametro
mov EBX,EAX			;Hago una copia del puntero


;Compruebo que el segundo parametro sea "-h"
cmp BYTE [EAX], 2Dh		;Comparo el primer caracter con "-"
jne abrir_archivo		;Si no es "-" procedo a abrir el archivo
inc EAX				;incremento el puntero
cmp BYTE [EAX], 68h		;Comparo el segundo caracter con "h"
jne salir_error			;Si no es "h", procedo a abrir el archivo
inc EAX				;Incremento el puntero
cmp BYTE [EAX], 0h		;Comparo con el caracter nulo
jne salir_error			;Si no es caracter nulo salgo con error
jmp imprimir_ayuda		;Si el argv es "-h" imprimo la ayuda

abrir_archivo:

;Abro el archivo que tiene el texto a imprimir, la ruta al archivo se encuentra en EBX
mov EAX,5			;Pongo el numero de llamada al sistema para abrir el archivo
mov ECX,0			;Voy a abrir el archivo en solo lectura
int 80h

cmp EAX,-1			;Si hubo error el descriptor del archivo sera -1 y salgo con error 2
je salir_error_archivo

push EAX			;Guardo el descriptor del archivo para cerrarlo despues

mov EBX,EAX			;Pongo el descriptor del archivo en EBX
mov EAX,3			;LLamada al sistema para leer
mov ECX,buffer			;Buffer donde va a quedar el archivo
mov EDX,1048576			;Tamaño maximo del buffer
int 80h

leer_linea:

;Cargo el caracter del archivo
mov EBX,buffer			;Muevo la direccion inicial del buffer
add EBX,[contador]		;Le sumo el contador donde tengo que char leer
mov CL,[EBX]			;Copio el caracter almacenado en la posicion buffer+contador
cmp CL, 0			;Si el caracter=0 termine de leer el archivo
je fin_archivo			;Salto a fin_archivo

push ECX			;Guardo el caracter

;Escribo en la posicion correspondiente de la linea el caracter que leo del buffer
mov EAX,linea			;Muevo la direccion inicial de la linea
add EAX,[char_pos]		;Le summo el offset
call caracter_imprimible	;Convierte el caracter leido en un caracter imprimible
mov [EAX],CL			;Copio el caracter que lei en linea+char_pos

pop ECX				;Saco el caracter que lei de la pila

mov EAX,linea			;Muevo la direccion inicial de la linea
add EAX,[hex_pos]		;Le sumo el offset
call caracter_hexa		;Convierto el caracter en hexadecimal
mov [EAX],CX			;Lo escribo en la linea


inc DWORD [contador]		;Incremento el contador de caracteres
inc DWORD [char_pos]		;Incremento la posicion donde escribir caracteres en la linea
add [hex_pos],DWORD 3		;Incremento la posicion donde escribir el hexa en la linea

;Veo si el contador es multiplo de 16, para cambiar de linea
mov EAX,[contador]		;Muevo el contador al registro EAX como dividendo
mov EBX,linea_max		;Muevo un 16 como divisor
mov EDX,0			;Reseteo EDX con 0
idiv EBX			;Uso division entera
cmp EDX,0			;Si el resto es 0 salto a resetear la linea para leer una nueva
je reset

jmp leer_linea			;Vuelvo a leer un caracter

reset:

;Imprimo la linea por pantalla
mov EAX,4
mov EBX,1
mov ECX,linea
mov EDX,lineal
int 80h

;Reseteo las posiciones donde voy a escribir los caracteres
mov [char_pos],DWORD char_offset		;char_pos=57
mov [hex_pos],DWORD hex_offset			;hex_pos=8



mov EAX,[contador]
mov EBX,linea
call caracter_contador

call imprimir_salto

jmp leer_linea					;Vuelvo a imprimir una linea

fin_archivo:

;Si no hay nada mas para imprimir salgo a imprimir el contador
mov EAX,[contador]		;Muevo el contador
mov EDX,0			;Reseteo EDX en 0
mov EBX,linea_max		;Muevo a EBX 16
idiv EBX			;Divido contador/16
cmp EDX,0			;Comparo el resto con 0
je imprimir_contador		;Si es 0 no hay nada mas para copiar

sub EBX,EDX		;16-resto
mov [resto], EBX	;Guardo el resto para saber cuantos caracteres tengo que reemplazar

;Agrego una sola vez una barra vertical al final de los caracteres
mov EAX,linea
add EAX,[char_pos]
mov BL,BYTE [barra]
mov [EAX], BL
inc BYTE [char_pos]

reemplazar:
;Reemplazo todos los caracteres restantes con espacios

  cmp [resto], WORD 0
  je imprimir_faltante

  ;Reemplazo el caracter en la linea por un espacio
  mov EAX,linea
  add EAX,[char_pos]
  mov BL,[espacio]
  mov [EAX],BL
  inc BYTE [char_pos]

  ;Reemplazo los dos hexadecimales por dos espacios
  mov EAX,linea
  add EAX,[hex_pos]
  mov BL,[espacio]
  mov BH,[espacio]
  mov [EAX],BX
  add BYTE [hex_pos],3

  dec BYTE [resto]

  jmp reemplazar

imprimir_faltante:
;Imprimo la linea que falta
mov EAX,4
mov EBX,1
mov ECX,linea
mov EDX,lineal
int 80h

call imprimir_salto


imprimir_contador:

mov EAX,[contador]
mov EBX,buffer0s
call caracter_contador

mov EAX,4
mov EBX,1
mov ECX,buffer0s
mov EDX,buffer0sl
int 80h

call imprimir_salto

;salgo correctamente
mov EAX,1
mov EBX,0
int 80h





imprimir_ayuda:

;Imprimo el texto de ayuda
mov EAX,4
mov EBX,1
mov ECX,ayuda
mov EDX,ayudal
int 80h

call imprimir_salto		;Imprimo un salto de linea

; Salgo sin error
mov EAX,1
mov EBX,0
int 80h

salir_error:

;Salgo con error 1
mov EAX,1
mov EBX,1
int 80h

salir_error_archivo:

;Salgo con error 2
mov EAX,1
mov EBX,2
int 80h
