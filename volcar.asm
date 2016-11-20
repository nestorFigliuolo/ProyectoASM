
section .data

  ayuda db "Ayuda"
  ayudal equ $ - ayuda
  salto db 0xa			;Salto de line
  lineal db 75			;largo de una linea
  contador db 3			;contador de lineas

section .bss

  buffer: resb 1048576		;Buffer para leer de archivo
  linea: resb 75		;Buffer para crear una linea a imprimir

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

mov EAX,4
mov EBX,1
mov ECX,buffer
mov EDX,16
int 80h

call imprimir_salto


mov EAX,4
mov EBX,1
mov ECX,buffer
add ECX,16
mov EDX, 16
int 80h

call imprimir_salto

mov EAX,4
mov EBX,1
mov ECX, buffer
mov EDX,16
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
