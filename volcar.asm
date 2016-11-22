
%include "itoa.asm"

%define hex_offset 8
%define char_offset 57
%define linea_max 16

section .data

  ayuda db "Ayuda"
  ayudal equ $ - ayuda
  linea db "00000  hh hh hh hh hh hh hh hh hh hh hh hh hh hh hh hh  |cccccccccccccccc|"
  lineal equ $ - linea
  salto db 0xa				;Salto de line
  contador dd 0 			;contador de lineas
  hex_pos dd hex_pos			;offset a la posicion de la linea para insertar la representacion hexadecimal
  char_pos dd char_offset		;offset a la posicion de la linea donde insertar el char

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


mov EAX,linea
add EAX,[char_pos]
mov EBX,buffer
add EBX,[contador]
mov ECX,0
mov CX,[EBX]
push EAX
mov EAX,0
mov AL,CL
call imprimir_itoa
cmp CL, 0
je fin_archivo
pop EAX
mov [EAX],CL

inc DWORD [contador]

inc DWORD [char_pos]

mov EAX,[contador]
mov EBX,linea_max
mov EDX,0
idiv EBX
cmp EDX,0
je reset

jmp leer_linea

reset:
mov EAX,4
mov EBX,1
mov ECX,linea
mov EDX,lineal
int 80h

mov [char_pos],DWORD char_offset
mov [hex_pos],DWORD hex_offset

mov EAX,[char_pos]
call imprimir_itoa
call imprimir_salto

;jmp leer_linea

fin_archivo:
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
