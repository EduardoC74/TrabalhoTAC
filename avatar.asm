;------------------------------------------------------------------------
;	Base para TRABALHO PRATICO - TECNOLOGIAS e ARQUITECTURAS de COMPUTADORES
;
;	ANO LECTIVO 2020/2021
;--------------------------------------------------------------
; Demostra��o da navega��o do Ecran com um avatar
;
;		arrow keys to move
;		press ESC to exit
;
;--------------------------------------------------------------

.8086
.model small
.stack 2048

dseg	segment para public 'data'


		STR12	 		DB 		"            "	; String para 12 digitos
		STR13	 		DB 		"            "	; String para 12 digitos
		DDMMAAAA 		db		"                     "
		NUMERO		    DB		"                    $" 	; String destinada a guardar o número lido

		Horas			dw		0				; Vai guardar a HORA actual
		Minutos			dw		0				; Vai guardar os minutos actuais
		Segundos		dw		0				; Vai guardar os segundos actuais
		segundosaux     dw      0
		Old_seg			dw		0				; Guarda os �ltimos segundos que foram lidos
		Tempo_init		dw		0				; Guarda O Tempo de inicio do jogo
		Tempo_j			dw		0				; Guarda O Tempo que decorre o  jogo
		Tempo_limite	dw		100				; tempo m�ximo de Jogo
		tempoaux        dw      0
		menuaux         dw      0
		String_tempo1	db		"    /100$"
		String_tempo2	db		"    /85$"
		String_tempo3	db		"    /70$"
		String_tempo4	db		"    /55$"
		String_tempo5	db		"    /40$"

		String_num 		db 		"  0 $"
        String_nome1  	db	    "CPU  $"
		String_nivel1   db      "NIVEL 1  $"
		String_nome2  	db	    "INPUT  $"
		String_nivel2   db      "NIVEL 2  $"
		String_nome3  	db	    "REGISTO  $"
		String_nivel3   db      "NIVEL 3  $"
		String_nome4  	db	    "PROCESSADOR  $"
		String_nivel4   db      "NIVEL 4  $"
		String_nome5  	db	    "IDENTIFICADOR  $"
		String_nivel5   db      "NIVEL 5  $"
		Construir_nome1	db	    "     $"
		Construir_nome2	db	    "       $"
		Construir_nome3	db	    "         $"
		Construir_nome4	db	    "             $"
		Construir_nome5	db	    "               $"  
		Dim_nome		dw		5	; Comprimento do Nome
		indice_nome		dw		0	; indice que aponta para Construir_nome

		Fim_Ganhou		db	    " Ganhou! $"
		Fim_Perdeu		db	    " Perdeu! $"
		GanhouTudo      db      "Parabens, voce completou os 5 niveis com sucesso! :)  $"
		PerdeuTudo      db       "Ups, o tempo acabou! :(     Tente novamente! $"

        Erro_Open       db      'Erro ao tentar abrir o ficheiro$'
        Erro_Ler_Msg    db      'Erro ao tentar ler do ficheiro$'
        Erro_Close      db      'Erro ao tentar fechar o ficheiro$'
        Fich         	db      'labi.TXT',0
		menuFich        db      "menu.TXT",0
		top10Fich       db      "top10.TXT",0
        HandleFich      dw      0
        car_fich        db      ?

		string			db	"Teste pr�tico de T.I",0
		Car				db	32	; Guarda um caracter do Ecran
		CARAUX          db  32
		Cor				db	7	; Guarda os atributos de cor do caracter
		POSy			db	3	; a linha pode ir de [1 .. 25]
		CURPOSy         db  3
		POSx			db	3	; POSx pode ir [1..80]
		CURPOSx         db  3
		aleatx1         db  3
		POSya			db	3	; Posi��o anterior de y
		POSxa			db	3	; Posi��o anterior de x

	    ultimo_num_alea dw 0
				
dseg	ends

cseg	segment para public 'code'
assume		cs:cseg, ds:dseg



;########################################################################
goto_xy	macro	POSx,POSy
		mov		ah,02h
		mov		bh,0		; numero da p�gina
		mov		dl,POSx
		mov		dh,POSy
		int		10h
endm

;########################################################################
; MOSTRA - Faz o display de uma string terminada em $

MOSTRA MACRO STR
MOV AH,09H
LEA DX,STR
INT 21H
ENDM

; FIM DAS MACROS

;********************************************************************************
;********************************************************************************
; HORAS  - LE Hora DO SISTEMA E COLOCA em tres variaveis (Horas, Minutos, Segundos)
; CH - Horas, CL - Minutos, DH - Segundos
;********************************************************************************	

Ler_TEMPO PROC	
 
		PUSH AX
		PUSH BX
		PUSH CX
		PUSH DX
	
		PUSHF
		
		MOV AH, 2CH             ; Buscar a hORAS
		INT 21H                 
		
		XOR AX,AX
		MOV AL, DH              ; segundos para al
		mov Segundos, AX		; guarda segundos na variavel correspondente
		
		XOR AX,AX
		MOV AL, CL              ; Minutos para al
		mov Minutos, AX         ; guarda MINUTOS na variavel correspondente
		
		XOR AX,AX
		MOV AL, CH              ; Horas para al
		mov Horas,AX			; guarda HORAS na variavel correspondente
 
		POPF
		POP DX
		POP CX
		POP BX
		POP AX
 		RET 
Ler_TEMPO   ENDP 

;------------------------------------------------------
;CalcAleat - calcula um numero aleatorio de 16 bits
;Parametros passados pela pilha
;entrada:
;n�o tem parametros de entrada
;saida:
;param1 - 16 bits - numero aleatorio calculado
;notas adicionais:
; deve estar definida uma variavel => ultimo_num_aleat dw 0
; assume-se que DS esta a apontar para o segmento onde esta armazenada ultimo_num_aleat

;CalcAleat proc near

;	sub	sp,2
;	push	bp
;	mov	bp,sp
;	push	ax
;	push	cx
;	push	dx	
;	mov	ax,[bp+4]
;	mov	[bp+2],ax

;	mov	ah,00h
;	int	1ah

;	add	dx,ultimo_num_alea
;	add	cx,dx	
;	mov	ax,65521
;	push	dx
;	mul	cx
;	pop	dx
;	xchg	dl,dh
;	add	dx,32749
;	add	dx,ax

;	mov	ultimo_num_alea,dx

;	mov	[BP+4],dx

;	pop	dx
;	pop	cx
;	pop	ax
;	pop	bp

;	ret

;CalcAleat endp


;ROTINA PARA APAGAR ECRAN

apaga_ecran	proc
			mov		ax,0B800h
			mov		es,ax
			xor		bx,bx
			mov		cx,25*80

apaga:		mov		byte ptr es:[bx],' '
			mov		byte ptr es:[bx+1],7
			inc		bx
			inc 	bx
			loop	apaga
			ret
apaga_ecran	endp


;########################################################################
; IMP_FICH

IMP_FICH	PROC

		;abre ficheiro
        mov     ah,3dh
        mov     al,0
        int     21h
        jc      erro_abrir
        mov     HandleFich,ax
        jmp     ler_ciclo

erro_abrir:
        mov     ah,09h
        lea     dx,Erro_Open
        int     21h
        jmp     sai_f

ler_ciclo:
        mov     ah,3fh
        mov     bx,HandleFich
        mov     cx,1
        lea     dx,car_fich
        int     21h
		jc		erro_ler
		cmp		ax,0		;EOF?
		je		fecha_ficheiro
        mov     ah,02h
		mov		dl,car_fich
		int		21h
		jmp		ler_ciclo

erro_ler:
        mov     ah,09h
        lea     dx,Erro_Ler_Msg
        int     21h

fecha_ficheiro:
        mov     ah,3eh
        mov     bx,HandleFich
        int     21h
        jnc     sai_f

        mov     ah,09h
        lea     dx,Erro_Close
        Int     21h
sai_f:
		RET

IMP_FICH	endp

;********************************************************************************
;********************************************************************************
; LEITURA DE UMA TECLA DO TECLADO 
; LE UMA TECLA	E DEVOLVE VALOR EM AH E AL
; SE ah=0 É UMA TECLA NORMAL
; SE ah=1 É UMA TECLA EXTENDIDA
; AL DEVOLVE O CÓDIGO DA TECLA PREMIDA
LE_TECLA	PROC
sem_tecla:
		call Trata_Horas
		MOV	AH,0BH
		INT 21h
		cmp AL,0
		je	sem_tecla
		
		MOV	AH,08H
		INT	21H
		MOV	AH,0
		CMP	AL,0
		JNE	SAI_TECLA
		MOV	AH, 08H
		INT	21H
		MOV	AH,1
SAI_TECLA:	
		RET
LE_TECLA	ENDP

;********************************************************************************
;********************************************************************************
; Imprime o tempo no monitor
Trata_Horas PROC

    	PUSHF
		PUSH AX
		PUSH BX
		PUSH CX
		PUSH DX		

TRATA:	CALL 	Ler_TEMPO				; Horas MINUTOS e segundos do Sistema
		
		MOV		AX, Segundos
		cmp		AX, Old_seg			; VErifica se os segundos mudaram desde a ultima leitura
		je		fim_horas			; Se a hora não mudou desde a última leitura sai.
		mov		Old_seg, AX			; Se segundos são diferentes actualiza informação do tempo 
		
		mov 	ax,segundosaux
		MOV 	bl, 10     
		div 	bl
		add 	al, 30h				; Caracter Correspondente às dezenas
		add		ah,	30h				; Caracter Correspondente às unidades
		MOV 	STR12[0],al			; 
		MOV 	STR12[1],ah		
		MOV 	STR12[3],'$'
		GOTO_XY	 65,0
		MOSTRA	STR12 
		inc     segundosaux	

		cmp    tempoaux, 1
		je     verificatempo1
		cmp    tempoaux, 2
		je     verificatempo2
		cmp    tempoaux, 3
		je     verificatempo3
		cmp    tempoaux, 4
		je     verificatempo4
		cmp    tempoaux, 5
		je     verificatempo5

verificatempo1:
        cmp   segundosaux, 101
		jne   TRATA
		mov   ax,  segundosaux
		sub   segundosaux, ax
		mov   menuaux,1
		call  Main
verificatempo2:
        cmp   segundosaux, 86
		jne   TRATA
		mov   ax,  segundosaux
		sub   segundosaux, ax
		mov   menuaux,1
		call  Main
verificatempo3:
        cmp   segundosaux, 71
		jne   TRATA
		mov   ax,  segundosaux
		sub   segundosaux, ax
		mov   menuaux,1
		call  Main
verificatempo4:
        cmp   segundosaux, 56
		jne   TRATA
		mov   ax,  segundosaux
		sub   segundosaux, ax
		mov   menuaux,1
		call  Main
verificatempo5:
        cmp   segundosaux, 41
		jne   TRATA
		mov   ax,  segundosaux
		sub   segundosaux, ax
		mov   menuaux,1
		call  Main
		
fim_horas:		
		goto_xy	POSx,POSy			; Volta a colocar o cursor onde estava antes de actualizar as horas
		
		POPF
		POP DX		
		POP CX
		POP BX
		POP AX
		RET	
Trata_Horas ENDP

;########################################################################
; Avatar

AVATAR	PROC
			mov		ax,0B800h
			mov		es,ax

MENU:       
            cmp     menuaux, 0
			jne     MENU2
			call    apaga_ecran
			goto_xy 0,0     
			lea     dx, menuFich
			call    IMP_FICH
			mov     ah, 07h
			int     21H
			cmp     al, "1"
			je      JOGO1
			cmp     al, "2"
			je      TOP10
			cmp     al,"3"
			je      FIM
			jmp     MENU
MENU2:      
            mov      Construir_nome1[0],' '
			mov      Construir_nome1[1],' '
			mov      Construir_nome1[2],' '
			mov      Construir_nome2[0],' '
			mov      Construir_nome2[1],' '
			mov      Construir_nome2[2],' '
			mov      Construir_nome2[3],' '
			mov      Construir_nome2[4],' '
			mov      Construir_nome3[0],' '
			mov      Construir_nome3[1],' '
			mov      Construir_nome3[2],' '
			mov      Construir_nome3[3],' '
			mov      Construir_nome3[4],' '
			mov      Construir_nome3[5],' '
			mov      Construir_nome3[6],' '
			mov      Construir_nome4[0],' '
			mov      Construir_nome4[1],' '
			mov      Construir_nome4[2],' '
			mov      Construir_nome4[3],' '
			mov      Construir_nome4[4],' '
			mov      Construir_nome4[5],' '
			mov      Construir_nome4[6],' '
			mov      Construir_nome4[7],' '
			mov      Construir_nome4[8],' '
			mov      Construir_nome4[9],' '
			mov      Construir_nome4[10],' '
			mov      Construir_nome5[0],' '
			mov      Construir_nome5[1],' '
			mov      Construir_nome5[2],' '
			mov      Construir_nome5[3],' '
			mov      Construir_nome5[4],' '
			mov      Construir_nome5[5],' '
		    mov      Construir_nome5[6],' '
		    mov      Construir_nome5[7],' '
		    mov      Construir_nome5[8],' '
		    mov      Construir_nome5[9],' '	
			mov      Construir_nome5[10],' '
			mov      Construir_nome5[11],' '
			mov      Construir_nome5[12],' '
			call    apaga_ecran
			goto_xy 0,0     
			lea     dx, menuFich
			call    IMP_FICH
			goto_xy  17, 24
		    MOSTRA   PerdeuTudo
			mov     ah, 07h
			int     21H
			cmp     al, "1"
			je      JOGO1
			cmp     al, "2"
			je      TOP10
			cmp     al,"3"
			je      FIM
			jmp     MENU

MENU3:     
            mov      Construir_nome1[0],' '
			mov      Construir_nome1[1],' '
			mov      Construir_nome1[2],' '
			mov      Construir_nome2[0],' '
			mov      Construir_nome2[1],' '
			mov      Construir_nome2[2],' '
			mov      Construir_nome2[3],' '
			mov      Construir_nome2[4],' '
			mov      Construir_nome3[0],' '
			mov      Construir_nome3[1],' '
			mov      Construir_nome3[2],' '
			mov      Construir_nome3[3],' '
			mov      Construir_nome3[4],' '
			mov      Construir_nome3[5],' '
			mov      Construir_nome3[6],' '
			mov      Construir_nome4[0],' '
			mov      Construir_nome4[1],' '
			mov      Construir_nome4[2],' '
			mov      Construir_nome4[3],' '
			mov      Construir_nome4[4],' '
			mov      Construir_nome4[5],' '
			mov      Construir_nome4[6],' '
			mov      Construir_nome4[7],' '
			mov      Construir_nome4[8],' '
			mov      Construir_nome4[9],' '
			mov      Construir_nome4[10],' '
			mov      Construir_nome5[0],' '
			mov      Construir_nome5[1],' '
			mov      Construir_nome5[2],' '
			mov      Construir_nome5[3],' '
			mov      Construir_nome5[4],' '
			mov      Construir_nome5[5],' '
		    mov      Construir_nome5[6],' '
		    mov      Construir_nome5[7],' '
		    mov      Construir_nome5[8],' '
		    mov      Construir_nome5[9],' '	
			mov      Construir_nome5[10],' '
			mov      Construir_nome5[11],' '
			mov      Construir_nome5[12],' '
			call    apaga_ecran
			goto_xy 0,0     
			lea     dx, menuFich
			call    IMP_FICH
			goto_xy  15, 24
		    MOSTRA   GanhouTudo
			mov     ah, 07h
			int     21H
			cmp     al, "1"
			je      LAB1
			cmp     al, "2"
			je      TOP10
			cmp     al,"3"
			je      FIM
			jmp     MENU

;NIVEL 1
LAB1:
			goto_xy	POSx,POSy		; Vai para nova posi��o
			mov 	ah, 08h		; Guarda o Caracter que est� na posi��o do Cursor
			mov		bh,0			; numero da p�gina
			int		10h
			mov		Car, al			; Guarda o Caracter que est� na posi��o do Cursor
			mov		Cor, ah			; Guarda a cor que est� na posi��o do Cursor

    	    goto_xy	POSxa,POSya		; Vai para a posi��o anterior do cursor
			mov		ah, 02h
			mov		dl, Car			; Repoe Caracter guardado
			int		21H

	        mov POSx, 35
			mov POSy, 20
JOGO1:
            call    apaga_ecran
			goto_xy 0,0
			lea     dx, Fich
			call    IMP_FICH
			goto_xy 64,0
			MOSTRA  String_tempo1
			goto_xy 35,0
			MOSTRA  String_nivel1
			goto_xy 10, 22
			MOSTRA  String_nome1
			mov     ax,  segundosaux
			sub     segundosaux, ax
			mov     ax, 1
			mov     tempoaux, ax

			goto_xy	POSx,POSy		; Vai para nova posi��o
			mov 	ah, 08h		; Guarda o Caracter que est� na posi��o do Cursor
			mov		bh,0			; numero da p�gina
			int		10h
			mov		Car, al			; Guarda o Caracter que est� na posi��o do Cursor
			mov		Cor, ah			; Guarda a cor que est� na posi��o do Cursor

			mov POSx, 4
			mov POSy, 3
CICLO1:	    
            goto_xy	POSxa,POSya		; Vai para a posi��o anterior do cursor
			mov		ah, 02h
			mov		dl, Car			; Repoe Caracter guardado
			int		21H

			goto_xy	POSx,POSy		; Vai para nova posi��o
			mov 	ah, 08h
			mov		bh,0			; numero da p�gina
			int		10h
			mov		Car, al			; Guarda o Caracter que est� na posi��o do Cursor
			mov		Cor, ah			; Guarda a cor que est� na posi��o do Cursor
			cmp     Car, 'C'
			je      letraC1
			cmp     Car, 'P'
			je      letraP1
			cmp     Car, 'U'
			je      letraU1

mostracima1:
            goto_xy 78, 0
			mov     ah, 02h
			mov     dl, Car
            int     21H
			goto_xy	POSx,POSy		; Vai para posi��o do cursor
IMPRIME1:	mov		ah, 02h
			mov		dl, 190	; Coloca AVATAR
			int		21H
			goto_xy	POSx,POSy	; Vai para posi��o do cursor

			mov		al, POSx	; Guarda a posi��o do cursor
			mov		POSxa, al
			mov		al, POSy	; Guarda a posi��o do cursor
			mov 	POSya, al

LER_SETA1:	call 	LE_TECLA
			cmp		ah, 1
			je		ESTEND1
			CMP 	AL, 27	; ESCAPE
			JE		FIM
			jmp		LER_SETA1

ESTEND1:	cmp     al,48h ;cima
			jne		BAIXO1
			call    PAREDECIMA  
			jmp		CICLO1
BAIXO1:		cmp		al,50h ;Baixo
			jne		ESQUERDA1
			call    PAREDEBAIXO		
			jmp		CICLO1

ESQUERDA1:
			cmp		al,4Bh
			jne		DIREITA1
			call    PAREDEESQUERDA		;Esquerda
			jmp		CICLO1

DIREITA1:
			cmp		al,4Dh
			jne		LER_SETA1
			call    PAREDEDIREITA		;Direita
			jmp		CICLO1

letraC1:
           mov      Construir_nome1[0],'C'
		   ;mov      Car,' '
		   goto_xy  10,23
		   MOSTRA   Construir_nome1
		   cmp      Construir_nome1[1],'P'
		   jne      mostracima1
		   cmp      Construir_nome1[2],'U'
		   jne      mostracima1
		   call     apaga_ecran
		   jmp      LAB2

letraP1:
           mov      Construir_nome1[1],'P'
		   ;mov      Car,' '
		   goto_xy  10,23
		   MOSTRA   Construir_nome1
           cmp      Construir_nome1[0],'C' 
		   jne      mostracima1
		   cmp      Construir_nome1[2],'U'
		   jne      mostracima1
		   call     apaga_ecran
		   jmp      LAB2
letraU1:
           mov      Construir_nome1[2],'U'
		   ;mov      Car,' '
		   goto_xy  10,23
		   MOSTRA   Construir_nome1
           cmp      Construir_nome1[0],'C'  
		   jne      mostracima1
		   cmp      Construir_nome1[1],'P' 
		   jne      mostracima1
		   call     apaga_ecran
           jmp      LAB2

;NIVEL 2
LAB2:
			goto_xy	POSx,POSy		; Vai para nova posi��o
			mov 	ah, 08h		; Guarda o Caracter que est� na posi��o do Cursor
			mov		bh,0			; numero da p�gina
			int		10h
			mov		Car, al			; Guarda o Caracter que est� na posi��o do Cursor
			mov		Cor, ah			; Guarda a cor que est� na posi��o do Cursor

    	    goto_xy	POSxa,POSya		; Vai para a posi��o anterior do cursor
			mov		ah, 02h
			mov		dl, Car			; Repoe Caracter guardado
			int		21H

	        mov POSx, 35
			mov POSy, 20
JOGO2:	    
			goto_xy 0,0
			lea     dx, Fich
			call    IMP_FICH
			goto_xy 64,0
			MOSTRA  String_tempo2
			goto_xy 35,0
			MOSTRA  String_nivel2
			goto_xy 10, 22
			MOSTRA  String_nome2
			mov     ax,  segundosaux
			sub     segundosaux, ax
			mov     ax, 2
			mov     tempoaux, ax
CICLO2:	    goto_xy	POSxa,POSya		; Vai para a posi��o anterior do cursor
			mov		ah, 02h
			mov		dl, Car			; Repoe Caracter guardado
			int		21H

    		goto_xy	POSx,POSy		; Vai para nova posi��o
			mov 	ah, 08h
			mov		bh,0			; numero da p�gina
			int		10h
			mov		Car, al			; Guarda o Caracter que est� na posi��o do Cursor
			mov		Cor, ah			; Guarda a cor que est� na posi��o do Cursor
			cmp     Car, 'I'
			je      letraI2
			cmp     Car, 'N'
			je      letraN2
			cmp     Car, 'P'
			je      letraP2
			cmp     Car, 'U'
			je      letraU2
			cmp     Car, 'T'
			je      letraT2

mostracima2:
            goto_xy 78, 0
			mov     ah, 02h
			mov     dl, Car
            int     21H
			goto_xy	POSx,POSy		; Vai para posi��o do cursor
IMPRIME2:	mov		ah, 02h
			mov		dl, 190	; Coloca AVATAR
			int		21H
			goto_xy	POSx,POSy	; Vai para posi��o do cursor

			mov		al, POSx	; Guarda a posi��o do cursor
			mov		POSxa, al
			mov		al, POSy	; Guarda a posi��o do cursor
			mov 	POSya, al

LER_SETA2:	call 	LE_TECLA
			cmp		ah, 1
			je		ESTEND2
			CMP 	AL, 27	; ESCAPE
			JE		FIM
			jmp		LER_SETA2

ESTEND2:	cmp     al,48h ;cima
			jne		BAIXO2
			call    PAREDECIMA  
			jmp		CICLO2

BAIXO2:		cmp		al,50h ;Baixo
			jne		ESQUERDA2
			call    PAREDEBAIXO		
			jmp		CICLO2

ESQUERDA2:
			cmp		al,4Bh
			jne		DIREITA2
			call    PAREDEESQUERDA		;Esquerda
			jmp		CICLO2

DIREITA2:
			cmp		al,4Dh
			jne		LER_SETA2
			call    PAREDEDIREITA		;Direita
			jmp		CICLO2

letraI2:
           mov      Construir_nome2[0],'I'
		   goto_xy  10,23
		   MOSTRA   Construir_nome2
		   cmp      Construir_nome2[1],'N'
		   jne      mostracima2
		   cmp      Construir_nome2[2],'P'
		   jne      mostracima2
		   cmp      Construir_nome2[3],'U'
		   jne      mostracima2
		   cmp      Construir_nome2[4],'T'
		   jne      mostracima2
		   call     apaga_ecran
		   jmp      LAB3
letraN2:
           mov      Construir_nome2[1],'N'
		   goto_xy  10,23
		   MOSTRA   Construir_nome2
		   cmp      Construir_nome2[0],'I'
		   jne      mostracima2
		   cmp      Construir_nome2[2],'P'
		   jne      mostracima2
		   cmp      Construir_nome2[3],'U'
		   jne      mostracima2
		   cmp      Construir_nome2[4],'T'
		   jne      mostracima2
		   call     apaga_ecran
		   jmp      LAB3

letraP2:
           mov      Construir_nome2[2],'P'
		   goto_xy  10,23
		   MOSTRA   Construir_nome2
		   cmp      Construir_nome2[0],'I'
		   jne      mostracima2
		   cmp      Construir_nome2[1],'N'
		   jne      mostracima2
		   cmp      Construir_nome2[3],'U'
		   jne      mostracima2
		   cmp      Construir_nome2[4],'T'
		   jne      mostracima2
		   call     apaga_ecran
		   jmp      LAB3
	
letraU2:
           mov      Construir_nome2[3],'U'
		   goto_xy  10,23
		   MOSTRA   Construir_nome2
		   cmp      Construir_nome2[0],'I'
		   jne      mostracima2
		   cmp      Construir_nome2[1],'N'
		   jne      mostracima2
		   cmp      Construir_nome2[2],'P'
		   jne      mostracima2
		   cmp      Construir_nome2[4],'T'
		   jne      mostracima2
		   call     apaga_ecran
		   jmp      LAB3

letraT2:
           mov      Construir_nome2[4],'T'
		   goto_xy  10,23
		   MOSTRA   Construir_nome2
		   cmp      Construir_nome2[0],'I'
		   jne      mostracima2
		   cmp      Construir_nome2[1],'N'
		   jne      mostracima2
		   cmp      Construir_nome2[2],'P'
		   jne      mostracima2
		   cmp      Construir_nome2[3],'U'
		   jne      mostracima2
		   call     apaga_ecran
		   jmp      LAB3

;NIVEL 3
LAB3:
     
			goto_xy	POSx,POSy		; Vai para nova posi��o
			mov 	ah, 08h		; Guarda o Caracter que est� na posi��o do Cursor
			mov		bh,0			; numero da p�gina
			int		10h
			mov		Car, al			; Guarda o Caracter que est� na posi��o do Cursor
			mov		Cor, ah			; Guarda a cor que est� na posi��o do Cursor

    	    goto_xy	POSxa,POSya		; Vai para a posi��o anterior do cursor
			mov		ah, 02h
			mov		dl, Car			; Repoe Caracter guardado
			int		21H

            mov POSx, 12
			mov POSy, 6
JOGO3:	    
			goto_xy 0,0
			lea     dx, Fich
			call    IMP_FICH
			goto_xy 64,0
			MOSTRA  String_tempo3
			goto_xy 35,0
			MOSTRA  String_nivel3
			goto_xy 10, 22
			MOSTRA  String_nome3
			mov     ax,  segundosaux
			sub     segundosaux, ax
			mov     ax, 3
			mov     tempoaux, ax

CICLO3:	    goto_xy	POSxa,POSya		; Vai para a posi��o anterior do cursor
			mov		ah, 02h
			mov		dl, Car			; Repoe Caracter guardado
			int		21H

    		goto_xy	POSx,POSy		; Vai para nova posi��o
			mov 	ah, 08h
			mov		bh,0			; numero da p�gina
			int		10h
			mov		Car, al			; Guarda o Caracter que est� na posi��o do Cursor
			mov		Cor, ah			; Guarda a cor que est� na posi��o do Cursor
			cmp     Car, 'R'
			je      letraR3
			cmp     Car, 'E'
			je      letraE3
			cmp     Car, 'G'
			je      letraG3
			cmp     Car, 'I'
			je      letraI3
			cmp     Car, 'S'
			je      letraS3
			cmp     Car, 'T'
			je      letraT3
			cmp     Car, 'O'
			je      letraO3

mostracima3:
            goto_xy 78, 0
			mov     ah, 02h
			mov     dl, Car
            int     21H
			goto_xy	POSx,POSy		; Vai para posi��o do cursor
IMPRIME3:	mov		ah, 02h
			mov		dl, 190	; Coloca AVATAR
			int		21H
			goto_xy	POSx,POSy	; Vai para posi��o do cursor

			mov		al, POSx	; Guarda a posi��o do cursor
			mov		POSxa, al
			mov		al, POSy	; Guarda a posi��o do cursor
			mov 	POSya, al

LER_SETA3:	call 	LE_TECLA
			cmp		ah, 1
			je		ESTEND3
			CMP 	AL, 27	; ESCAPE
			JE		FIM
			jmp		LER_SETA3

ESTEND3:	cmp     al,48h ;cima
			jne		BAIXO3
			call    PAREDECIMA  
			jmp		CICLO3

BAIXO3:		cmp		al,50h ;Baixo
			jne		ESQUERDA3
			call    PAREDEBAIXO		
			jmp		CICLO3

ESQUERDA3:
			cmp		al,4Bh
			jne		DIREITA3
			call    PAREDEESQUERDA		;Esquerda
			jmp		CICLO3

DIREITA3:
			cmp		al,4Dh
			jne		LER_SETA3
			call    PAREDEDIREITA		;Direita
			jmp		CICLO3

letraR3:
           mov      Construir_nome3[0],'R'
		   goto_xy  10,23
		   MOSTRA   Construir_nome3
		   cmp      Construir_nome3[1],'E'
		   jne      mostracima3
		   cmp      Construir_nome3[2],'G'
		   jne      mostracima3
		   cmp      Construir_nome3[3],'I'
		   jne      mostracima3
		   cmp      Construir_nome3[4],'S'
		   jne      mostracima3
		   cmp      Construir_nome3[5],'T'
		   jne      mostracima3
		   cmp      Construir_nome3[6],'O'
		   jne      mostracima3
		   call     apaga_ecran
		   jmp      LAB4
letraE3:
           mov      Construir_nome3[1],'E'
		   goto_xy  10,23
		   MOSTRA   Construir_nome3
		   cmp      Construir_nome3[0],'R'
		   jne      mostracima3
		   cmp      Construir_nome3[2],'G'
		   jne      mostracima3
		   cmp      Construir_nome3[3],'I'
		   jne      mostracima3
		   cmp      Construir_nome3[4],'S'
		   jne      mostracima3
		   cmp      Construir_nome3[5],'T'
		   jne      mostracima3
		   cmp      Construir_nome3[6],'O'
		   jne      mostracima3
		   call     apaga_ecran
		   jmp      LAB4

letraG3:
           mov      Construir_nome3[2],'G'
		   goto_xy  10,23
		   MOSTRA   Construir_nome3
		   cmp      Construir_nome3[0],'R'
		   jne      mostracima3
		   cmp      Construir_nome3[1],'E'
		   jne      mostracima3
		   cmp      Construir_nome3[3],'I'
		   jne      mostracima3
		   cmp      Construir_nome3[4],'S'
		   jne      mostracima3
		   cmp      Construir_nome3[5],'T'
		   jne      mostracima3
		   cmp      Construir_nome3[6],'O'
		   jne      mostracima3
		   call     apaga_ecran
		   jmp      LAB4
	
letraI3:
          mov      Construir_nome3[3],'I'
		   goto_xy  10,23
		   MOSTRA   Construir_nome3
		   cmp      Construir_nome3[0],'R'
		   jne      mostracima3
		   cmp      Construir_nome3[1],'E'
		   jne      mostracima3
		   cmp      Construir_nome3[2],'G'
		   jne      mostracima3
		   cmp      Construir_nome3[4],'S'
		   jne      mostracima3
		   cmp      Construir_nome3[5],'T'
		   jne      mostracima3
		   cmp      Construir_nome3[6],'O'
		   jne      mostracima3
		   call     apaga_ecran
		   jmp      LAB4

letraS3:
           mov      Construir_nome3[4],'S'
		   goto_xy  10,23
		   MOSTRA   Construir_nome3
		   cmp      Construir_nome3[0],'R'
		   jne      mostracima3
		   cmp      Construir_nome3[1],'E'
		   jne      mostracima3
		   cmp      Construir_nome3[2],'G'
		   jne      mostracima3
		   cmp      Construir_nome3[3],'I'
		   jne      mostracima3
		   cmp      Construir_nome3[5],'T'
		   jne      mostracima3
		   cmp      Construir_nome3[6],'O'
		   jne      mostracima3
		   call     apaga_ecran
		   jmp      LAB4
letraT3:
           mov      Construir_nome3[5],'T'
		   goto_xy  10,23
		   MOSTRA   Construir_nome3
		   cmp      Construir_nome3[0],'R'
		   jne      mostracima3
		   cmp      Construir_nome3[1],'E'
		   jne      mostracima3
		   cmp      Construir_nome3[2],'G'
		   jne      mostracima3
		   cmp      Construir_nome3[3],'I'
		   jne      mostracima3
		   cmp      Construir_nome3[4],'S'
		   jne      mostracima3
		   cmp      Construir_nome3[6],'O'
		   jne      mostracima3
		   call     apaga_ecran
		   jmp      LAB4
letraO3:
           mov      Construir_nome3[6],'O'
		   goto_xy  10,23
		   MOSTRA   Construir_nome3
		   cmp      Construir_nome3[0],'R'
		   jne      mostracima3
		   cmp      Construir_nome3[1],'E'
		   jne      mostracima3
		   cmp      Construir_nome3[2],'G'
		   jne      mostracima3
		   cmp      Construir_nome3[3],'I'
		   jne      mostracima3
		   cmp      Construir_nome3[4],'S'
		   jne      mostracima3
		   cmp      Construir_nome3[5],'T'
		   jne      mostracima3
		   call     apaga_ecran
		   jmp      LAB4

;NIVEL 4
LAB4:
     
			goto_xy	POSx,POSy		; Vai para nova posi��o
			mov 	ah, 08h		; Guarda o Caracter que est� na posi��o do Cursor
			mov		bh,0			; numero da p�gina
			int		10h
			mov		Car, al			; Guarda o Caracter que est� na posi��o do Cursor
			mov		Cor, ah			; Guarda a cor que est� na posi��o do Cursor

    	    goto_xy	POSxa,POSya		; Vai para a posi��o anterior do cursor
			mov		ah, 02h
			mov		dl, Car			; Repoe Caracter guardado
			int		21H

            mov POSx, 48
			mov POSy, 11
JOGO04:	    
			goto_xy 0,0
			lea     dx, Fich
			call    IMP_FICH
			goto_xy 64,0
			MOSTRA  String_tempo4
			goto_xy 35,0
			MOSTRA  String_nivel4
			goto_xy 10, 22
			MOSTRA  String_nome4
			mov     ax,  segundosaux
			sub     segundosaux, ax
			mov     ax, 4
			mov     tempoaux, ax

CICLO4:	    goto_xy	POSxa,POSya		; Vai para a posi��o anterior do cursor
			mov		ah, 02h
			mov		dl, Car			; Repoe Caracter guardado
			int		21H

    		goto_xy	POSx,POSy		; Vai para nova posi��o
			mov 	ah, 08h
			mov		bh,0			; numero da p�gina
			int		10h
			mov		Car, al			; Guarda o Caracter que est� na posi��o do Cursor
			mov		Cor, ah			; Guarda a cor que est� na posi��o do Cursor
			cmp     Car, 'P'
			je      letraP4
			cmp     Car, 'R'
			je      letraR4
			cmp     Car, 'O'
			je      letraO4
			cmp     Car, 'C'
			je      letraC4
			cmp     Car, 'E'
			je      letraE4
			cmp     Car, 'S'
			je      letraS4
			cmp     Car, 'A'
			je      letraA4
			cmp     Car, 'D'
			je      letraD4

mostracima4:
            goto_xy 78, 0
			mov     ah, 02h
			mov     dl, Car
            int     21H
			goto_xy	POSx,POSy		; Vai para posi��o do cursor
IMPRIME4:	mov		ah, 02h
			mov		dl, 190	; Coloca AVATAR
			int		21H
			goto_xy	POSx,POSy	; Vai para posi��o do cursor

			mov		al, POSx	; Guarda a posi��o do cursor
			mov		POSxa, al
			mov		al, POSy	; Guarda a posi��o do cursor
			mov 	POSya, al

LER_SETA4:	call 	LE_TECLA
			cmp		ah, 1
			je		ESTEND4
			CMP 	AL, 27	; ESCAPE
			JE		FIM
			jmp		LER_SETA4

ESTEND4:	cmp     al,48h ;cima
			jne		BAIXO4
			call    PAREDECIMA  
			jmp		CICLO4

BAIXO4:		cmp		al,50h ;Baixo
			jne		ESQUERDA4
			call    PAREDEBAIXO		
			jmp		CICLO4

ESQUERDA4:
			cmp		al,4Bh
			jne		DIREITA4
			call    PAREDEESQUERDA		;Esquerda
			jmp		CICLO4

DIREITA4:
			cmp		al,4Dh
			jne		LER_SETA4
			call    PAREDEDIREITA		;Direita
			jmp		CICLO4

letraP4:
           mov      Construir_nome4[0],'P'
		   goto_xy  10,23
		   MOSTRA   Construir_nome4
		   cmp      Construir_nome4[1],'R'
		   jne      mostracima4
		   cmp      Construir_nome4[2],'O'
		   jne      mostracima4
		   cmp      Construir_nome4[3],'C'
		   jne      mostracima4
		   cmp      Construir_nome4[4],'E'
		   jne      mostracima4
		   cmp      Construir_nome4[5],'S'
		   jne      mostracima4
		   cmp      Construir_nome4[6],'S'
		   jne      mostracima4
		   cmp      Construir_nome4[7],'A'
		   jne      mostracima4
		   cmp      Construir_nome4[8],'D'
		   jne      mostracima4
		   cmp      Construir_nome4[9],'O'
		   jne      mostracima4
		   cmp      Construir_nome4[10],'R'
		   jne      mostracima4
		   call     apaga_ecran
		   jmp      LAB5
letraR4:
           mov      Construir_nome4[1],'R'
		   mov      Construir_nome4[10],'R'
		   goto_xy  10,23
		   MOSTRA   Construir_nome4
		   cmp      Construir_nome4[0],'P'
		   jne      mostracima4
		   cmp      Construir_nome4[2],'O'
		   jne      mostracima4
		   cmp      Construir_nome4[3],'C'
		   jne      mostracima4
		   cmp      Construir_nome4[4],'E'
		   jne      mostracima4
		   cmp      Construir_nome4[5],'S'
		   jne      mostracima4
		   cmp      Construir_nome4[6],'S'
		   jne      mostracima4
		   cmp      Construir_nome4[7],'A'
		   jne      mostracima4
		   cmp      Construir_nome4[8],'D'
		   jne      mostracima4
		   cmp      Construir_nome4[9],'O'
		   jne      mostracima4
		   call     apaga_ecran
		   jmp      LAB5

letraO4:
           mov      Construir_nome4[2],'O'
		   mov      Construir_nome4[9],'O'
		   goto_xy  10,23
		   MOSTRA   Construir_nome4
		   cmp      Construir_nome4[0],'P'
		   jne      mostracima4
		   cmp      Construir_nome4[1],'R'
		   jne      mostracima4
		   cmp      Construir_nome4[3],'C'
		   jne      mostracima4
		   cmp      Construir_nome4[4],'E'
		   jne      mostracima4
		   cmp      Construir_nome4[5],'S'
		   jne      mostracima4
		   cmp      Construir_nome4[6],'S'
		   jne      mostracima4
		   cmp      Construir_nome4[7],'A'
		   jne      mostracima4
		   cmp      Construir_nome4[8],'D'
		   jne      mostracima4
		   cmp      Construir_nome4[10],'R'
		   jne      mostracima4
		   call     apaga_ecran
		   jmp      LAB5
	
letraC4:
           mov      Construir_nome4[3],'C'
		   goto_xy  10,23
		   MOSTRA   Construir_nome4
		   cmp      Construir_nome4[0],'P'
		   jne      mostracima4
		   cmp      Construir_nome4[1],'R'
		   jne      mostracima4
		   cmp      Construir_nome4[2],'O'
		   jne      mostracima4
		   cmp      Construir_nome4[4],'E'
		   jne      mostracima4
		   cmp      Construir_nome4[5],'S'
		   jne      mostracima4
		   cmp      Construir_nome4[6],'S'
		   jne      mostracima4
		   cmp      Construir_nome4[7],'A'
		   jne      mostracima4
		   cmp      Construir_nome4[8],'D'
		   jne      mostracima4
		   cmp      Construir_nome4[9],'O'
		   jne      mostracima4
		   cmp      Construir_nome4[10],'R'
		   jne      mostracima4
		   call     apaga_ecran
		   jmp      LAB5

letraE4:
           mov      Construir_nome4[4],'E'
		   goto_xy  10,23
		   MOSTRA   Construir_nome4
		   cmp      Construir_nome4[0],'P'
		   jne      mostracima4
		   cmp      Construir_nome4[1],'R'
		   jne      mostracima4
		   cmp      Construir_nome4[2],'O'
		   jne      mostracima4
		   cmp      Construir_nome4[3],'C'
		   jne      mostracima4
		   cmp      Construir_nome4[5],'S'
		   jne      mostracima4
		   cmp      Construir_nome4[6],'S'
		   jne      mostracima4
		   cmp      Construir_nome4[7],'A'
		   jne      mostracima4
		   cmp      Construir_nome4[8],'D'
		   jne      mostracima4
		   cmp      Construir_nome4[9],'O'
		   jne      mostracima4
		   cmp      Construir_nome4[10],'R'
		   jne      mostracima4
		   call     apaga_ecran
		   jmp      LAB5
letraS4:
           mov      Construir_nome4[5],'S'
		   mov      Construir_nome4[6],'S'
		   goto_xy  10,23
		   MOSTRA   Construir_nome4
		   cmp      Construir_nome4[0],'P'
		   jne      mostracima4
		   cmp      Construir_nome4[1],'R'
		   jne      mostracima4
		   cmp      Construir_nome4[2],'O'
		   jne      mostracima4
		   cmp      Construir_nome4[3],'C'
		   jne      mostracima4
		   cmp      Construir_nome4[4],'E'
		   jne      mostracima4
		   cmp      Construir_nome4[7],'A'
		   jne      mostracima4
		   cmp      Construir_nome4[8],'D'
		   jne      mostracima4
		   cmp      Construir_nome4[9],'O'
		   jne      mostracima4
		   cmp      Construir_nome4[10],'R'
		   jne      mostracima4
		   call     apaga_ecran
		   jmp      LAB5
letraA4:
           mov      Construir_nome4[7],'A'
		   goto_xy  10,23
		   MOSTRA   Construir_nome4
		   cmp      Construir_nome4[0],'P'
		   jne      mostracima4
		   cmp      Construir_nome4[1],'R'
		   jne      mostracima4
		   cmp      Construir_nome4[2],'O'
		   jne      mostracima4
		   cmp      Construir_nome4[3],'C'
		   jne      mostracima4
		   cmp      Construir_nome4[4],'E'
		   jne      mostracima4
		   cmp      Construir_nome4[5],'S'
		   jne      mostracima4
		   cmp      Construir_nome4[6],'S'
		   jne      mostracima4
		   cmp      Construir_nome4[8],'D'
		   jne      mostracima4
		   cmp      Construir_nome4[9],'O'
		   jne      mostracima4
		   cmp      Construir_nome4[10],'R'
		   jne      mostracima4
		   call     apaga_ecran
		   jmp      LAB5

letraD4:
           mov      Construir_nome4[8],'D'
		   goto_xy  10,23
		   MOSTRA   Construir_nome4
		   cmp      Construir_nome4[0],'P'
		   jne      mostracima4
		   cmp      Construir_nome4[1],'R'
		   jne      mostracima4
		   cmp      Construir_nome4[2],'O'
		   jne      mostracima4
		   cmp      Construir_nome4[3],'C'
		   jne      mostracima4
		   cmp      Construir_nome4[4],'E'
		   jne      mostracima4
		   cmp      Construir_nome4[5],'S'
		   jne      mostracima4
		   cmp      Construir_nome4[6],'S'
		   jne      mostracima4
		   cmp      Construir_nome4[7],'A'
		   jne      mostracima4
		   cmp      Construir_nome4[9],'O'
		   jne      mostracima4
		   cmp      Construir_nome4[10],'R'
		   jne      mostracima4
		   call     apaga_ecran
		   jmp      LAB5

;NIVEL 5	   
LAB5:
     
			goto_xy	POSx,POSy		; Vai para nova posi��o
			mov 	ah, 08h		; Guarda o Caracter que est� na posi��o do Cursor
			mov		bh,0			; numero da p�gina
			int		10h
			mov		Car, al			; Guarda o Caracter que est� na posi��o do Cursor
			mov		Cor, ah			; Guarda a cor que est� na posi��o do Cursor

    	    goto_xy	POSxa,POSya		; Vai para a posi��o anterior do cursor
			mov		ah, 02h
			mov		dl, Car			; Repoe Caracter guardado
			int		21H
            
			mov POSx, 76
			mov POSy, 4
JOGO05:	    
			goto_xy 0,0
			lea     dx, Fich
			call    IMP_FICH
			goto_xy 64,0
			MOSTRA  String_tempo5
			goto_xy 35,0
			MOSTRA  String_nivel5
			goto_xy 10, 22
			MOSTRA  String_nome5
			mov     ax,  segundosaux
			sub     segundosaux, ax
			mov     ax, 5
			mov     tempoaux, ax

CICLO5:	    goto_xy	POSxa,POSya		; Vai para a posi��o anterior do cursor
			mov		ah, 02h
			mov		dl, Car			; Repoe Caracter guardado
			int		21H

    		goto_xy	POSx,POSy		; Vai para nova posi��o
			mov 	ah, 08h
			mov		bh,0			; numero da p�gina
			int		10h
			mov		Car, al			; Guarda o Caracter que est� na posi��o do Cursor
			mov		Cor, ah			; Guarda a cor que est� na posi��o do Cursor
			cmp     Car, 'I'
			je      letraI5
			cmp     Car, 'D'
			je      letraD5
			cmp     Car, 'E'
			je      letraE5
			cmp     Car, 'N'
			je      letraN5
			cmp     Car, 'T'
			je      letraT5
			cmp     Car, 'F'
			je      letraF5
			cmp     Car, 'C'
			je      letraC5
			cmp     Car, 'A'
			je      letraA5
			cmp     Car, 'O'
			je      letraO5
			cmp     Car, 'R'
			je      letraR5
mostracima5:
            goto_xy 78, 0
			mov     ah, 02h
			mov     dl, Car
            int     21H
			goto_xy	POSx,POSy		; Vai para posi��o do cursor
IMPRIME5:	mov		ah, 02h
			mov		dl, 190	; Coloca AVATAR
			int		21H
			goto_xy	POSx,POSy	; Vai para posi��o do cursor

			mov		al, POSx	; Guarda a posi��o do cursor
			mov		POSxa, al
			mov		al, POSy	; Guarda a posi��o do cursor
			mov 	POSya, al

LER_SETA5:	call 	LE_TECLA
			cmp		ah, 1
			je		ESTEND5
			CMP 	AL, 27	; ESCAPE
			JE		FIM
			jmp		LER_SETA5

ESTEND5:	cmp     al,48h ;cima
			jne		BAIXO5
			call    PAREDECIMA  
			jmp		CICLO5

BAIXO5:		cmp		al,50h ;Baixo
			jne		ESQUERDA5
			call    PAREDEBAIXO		
			jmp		CICLO5

ESQUERDA5:
			cmp		al,4Bh
			jne		DIREITA5
			call    PAREDEESQUERDA		;Esquerda
			jmp		CICLO5

DIREITA5:
			cmp		al,4Dh
			jne		LER_SETA5
			call    PAREDEDIREITA		;Direita
			jmp		CICLO5

letraI5:
           mov      Construir_nome5[0],'I'
		   mov      Construir_nome5[5],'I'
		   mov      Construir_nome5[7],'I'
		   goto_xy  10,23
		   MOSTRA   Construir_nome5
		   cmp      Construir_nome5[1],'D'
		   jne      mostracima5
		   cmp      Construir_nome5[2],'E'
		   jne      mostracima5
		   cmp      Construir_nome5[3],'N'
		   jne      mostracima5
		   cmp      Construir_nome5[4],'T'
		   jne      mostracima5
		   cmp      Construir_nome5[6],'F'
		   jne      mostracima5
		   cmp      Construir_nome5[8],'C'
		   jne      mostracima5
		   cmp      Construir_nome5[9],'A'
		   jne      mostracima5
		   cmp      Construir_nome5[10],'D'
		   jne      mostracima5
		   cmp      Construir_nome5[11],'O'
		   jne      mostracima5
		   cmp      Construir_nome5[12],'R'
		   jne      mostracima5
		   call     apaga_ecran
		   jmp      MENU3
letraD5:
           mov      Construir_nome5[1],'D'
		   mov      Construir_nome5[10],'D'
		   goto_xy  10,23
		   MOSTRA   Construir_nome5
		   cmp      Construir_nome5[0],'I'
		   jne      mostracima5
		   cmp      Construir_nome5[2],'E'
		   jne      mostracima5
		   cmp      Construir_nome5[3],'N'
		   jne      mostracima5
		   cmp      Construir_nome5[4],'T'
		   jne      mostracima5
		   cmp      Construir_nome5[5],'I'
		   jne      mostracima5
		   cmp      Construir_nome5[6],'F'
		   jne      mostracima5
		   cmp      Construir_nome5[7],'I'
		   jne      mostracima5
		   cmp      Construir_nome5[8],'C'
		   jne      mostracima5
		   cmp      Construir_nome5[9],'A'
		   jne      mostracima5
		   cmp      Construir_nome5[11],'O'
		   jne      mostracima5
		   cmp      Construir_nome5[12],'R'
		   jne      mostracima5
		   call     apaga_ecran
		   jmp      MENU3
letraE5:
           mov      Construir_nome5[2],'E'
		   goto_xy  10,23
		   MOSTRA   Construir_nome5
		   cmp      Construir_nome5[0],'I'
		   jne      mostracima5
		   cmp      Construir_nome5[1],'D'
		   jne      mostracima5
		   cmp      Construir_nome5[3],'N'
		   jne      mostracima5
		   cmp      Construir_nome5[4],'T'
		   jne      mostracima5
		   cmp      Construir_nome5[5],'I'
		   jne      mostracima5
		   cmp      Construir_nome5[6],'F'
		   jne      mostracima5
		   cmp      Construir_nome5[7],'I'
		   jne      mostracima5
		   cmp      Construir_nome5[8],'C'
		   jne      mostracima5
		   cmp      Construir_nome5[9],'A'
		   jne      mostracima5
		   cmp      Construir_nome5[10],'D'
		   jne      mostracima5
		   cmp      Construir_nome5[11],'O'
		   jne      mostracima5
		   cmp      Construir_nome5[12],'R'
		   jne      mostracima5
		   call     apaga_ecran
		   jmp      MENU3
	
letraN5:
           mov      Construir_nome5[3],'N'
		   goto_xy  10,23
		   MOSTRA   Construir_nome5
		   cmp      Construir_nome5[0],'I'
		   jne      mostracima5
		   cmp      Construir_nome5[1],'D'
		   jne      mostracima5
		   cmp      Construir_nome5[2],'E'
		   jne      mostracima5
		   cmp      Construir_nome5[4],'T'
		   jne      mostracima5
		   cmp      Construir_nome5[5],'I'
		   jne      mostracima5
		   cmp      Construir_nome5[6],'F'
		   jne      mostracima5
		   cmp      Construir_nome5[7],'I'
		   jne      mostracima5
		   cmp      Construir_nome5[8],'C'
		   jne      mostracima5
		   cmp      Construir_nome5[9],'A'
		   jne      mostracima5
		   cmp      Construir_nome5[10],'D'
		   jne      mostracima5
		   cmp      Construir_nome5[11],'O'
		   jne      mostracima5
		   cmp      Construir_nome5[12],'R'
		   jne      mostracima5
		   call     apaga_ecran
		   jmp      MENU3

letraT5:
           mov      Construir_nome5[4],'T'
		   goto_xy  10,23
		   MOSTRA   Construir_nome5
		   cmp      Construir_nome5[0],'I'
		   jne      mostracima5
		   cmp      Construir_nome5[1],'D'
		   jne      mostracima5
		   cmp      Construir_nome5[2],'E'
		   jne      mostracima5
		   cmp      Construir_nome5[3],'N'
		   jne      mostracima5
		   cmp      Construir_nome5[5],'I'
		   jne      mostracima5
		   cmp      Construir_nome5[6],'F'
		   jne      mostracima5
		   cmp      Construir_nome5[7],'I'
		   jne      mostracima5
		   cmp      Construir_nome5[8],'C'
		   jne      mostracima5
		   cmp      Construir_nome5[9],'A'
		   jne      mostracima5
		   cmp      Construir_nome5[10],'D'
		   jne      mostracima5
		   cmp      Construir_nome5[11],'O'
		   jne      mostracima5
		   cmp      Construir_nome5[12],'R'
		   jne      mostracima5
		   call     apaga_ecran
		   jmp      MENU3
letraF5:
           mov      Construir_nome5[6],'F'
		   goto_xy  10,23
		   MOSTRA   Construir_nome5
		   cmp      Construir_nome5[0],'I'
		   jne      mostracima5
		   cmp      Construir_nome5[1],'D'
		   jne      mostracima5
		   cmp      Construir_nome5[2],'E'
		   jne      mostracima5
		   cmp      Construir_nome5[3],'N'
		   jne      mostracima5
		   cmp      Construir_nome5[4],'T'
		   jne      mostracima5
		   cmp      Construir_nome5[5],'I'
		   jne      mostracima5
		   cmp      Construir_nome5[7],'I'
		   jne      mostracima5
		   cmp      Construir_nome5[8],'C'
		   jne      mostracima5
		   cmp      Construir_nome5[9],'A'
		   jne      mostracima5
		   cmp      Construir_nome5[10],'D'
		   jne      mostracima5
		   cmp      Construir_nome5[11],'O'
		   jne      mostracima5
		   cmp      Construir_nome5[12],'R'
		   jne      mostracima5
		   call     apaga_ecran
		   jmp      MENU3
letraC5:
           mov      Construir_nome5[8],'C'
		   goto_xy  10,23
		   MOSTRA   Construir_nome5
		   cmp      Construir_nome5[0],'I'
		   jne      mostracima5
		   cmp      Construir_nome5[1],'D'
		   jne      mostracima5
		   cmp      Construir_nome5[2],'E'
		   jne      mostracima5
		   cmp      Construir_nome5[3],'N'
		   jne      mostracima5
		   cmp      Construir_nome5[4],'T'
		   jne      mostracima5
		   cmp      Construir_nome5[5],'I'
		   jne      mostracima5
		   cmp      Construir_nome5[6],'F'
		   jne      mostracima5
		   cmp      Construir_nome5[7],'I'
		   jne      mostracima5
		   cmp      Construir_nome5[9],'A'
		   jne      mostracima5
		   cmp      Construir_nome5[10],'D'
		   jne      mostracima5
		   cmp      Construir_nome5[11],'O'
		   jne      mostracima5
		   cmp      Construir_nome5[12],'R'
		   jne      mostracima5
		   call     apaga_ecran
		   jmp      MENU3

letraA5:
           mov      Construir_nome5[9],'A'
		   goto_xy  10,23
		   MOSTRA   Construir_nome5
		   cmp      Construir_nome5[0],'I'
		   jne      mostracima5
		   cmp      Construir_nome5[1],'D'
		   jne      mostracima5
		   cmp      Construir_nome5[2],'E'
		   jne      mostracima5
		   cmp      Construir_nome5[3],'N'
		   jne      mostracima5
		   cmp      Construir_nome5[4],'T'
		   jne      mostracima5
		   cmp      Construir_nome5[5],'I'
		   jne      mostracima5
		   cmp      Construir_nome5[6],'F'
		   jne      mostracima5
		   cmp      Construir_nome5[7],'I'
		   jne      mostracima5
		   cmp      Construir_nome5[8],'C'
		   jne      mostracima5
		   cmp      Construir_nome5[10],'D'
		   jne      mostracima5
		   cmp      Construir_nome5[11],'O'
		   jne      mostracima5
		   cmp      Construir_nome5[12],'R'
		   jne      mostracima5
		   call     apaga_ecran
		   jmp      MENU3
letraO5:
           mov      Construir_nome5[11],'O'
		   goto_xy  10,23
		   MOSTRA   Construir_nome5
		   cmp      Construir_nome5[0],'I'
		   jne      mostracima5
		   cmp      Construir_nome5[1],'D'
		   jne      mostracima5
		   cmp      Construir_nome5[2],'E'
		   jne      mostracima5
		   cmp      Construir_nome5[3],'N'
		   jne      mostracima5
		   cmp      Construir_nome5[4],'T'
		   jne      mostracima5
		   cmp      Construir_nome5[5],'I'
		   jne      mostracima5
		   cmp      Construir_nome5[6],'F'
		   jne      mostracima5
		   cmp      Construir_nome5[7],'I'
		   jne      mostracima5
		   cmp      Construir_nome5[8],'C'
		   jne      mostracima5
		   cmp      Construir_nome5[9],'A'
		   jne      mostracima5
		   cmp      Construir_nome5[10],'D'
		   jne      mostracima5
		   cmp      Construir_nome5[12],'R'
		   jne      mostracima5
		   call     apaga_ecran
		   jmp      MENU3
letraR5:
           mov      Construir_nome5[12],'R'
		   goto_xy  10,23
		   MOSTRA   Construir_nome5
		   cmp      Construir_nome5[0],'I'
		   jne      mostracima5
		   cmp      Construir_nome5[1],'D'
		   jne      mostracima5
		   cmp      Construir_nome5[2],'E'
		   jne      mostracima5
		   cmp      Construir_nome5[3],'N'
		   jne      mostracima5
		   cmp      Construir_nome5[4],'T'
		   jne      mostracima5
		   cmp      Construir_nome5[5],'I'
		   jne      mostracima5
		   cmp      Construir_nome5[6],'F'
		   jne      mostracima5
		   cmp      Construir_nome5[7],'I'
		   jne      mostracima5
		   cmp      Construir_nome5[8],'C'
		   jne      mostracima5
		   cmp      Construir_nome5[9],'A'
		   jne      mostracima5                     
		   cmp      Construir_nome5[10],'D'
		   jne      mostracima5
		   cmp      Construir_nome5[12],'O'
		   jne      mostracima5
		   call     apaga_ecran
		   jmp      MENU3

TOP10:
           call    apaga_ecran
		   goto_xy 0,0
		   lea     dx, top10Fich
		   call    IMP_FICH
		   
FIM:
			RET
AVATAR		endp
PAREDECIMA PROC
           mov      al, POSy
		   mov      CURPOSy, al
           dec      CURPOSy
		   goto_xy  POSx, CURPOSy
		   mov   	ah, 08h
		   mov		bh,0		
		   int		10h
		   mov		CARAUX, al	
		   ;mov		Cor, ah
		   cmp      CARAUX, 177
		   je       CIMA 
		   dec      POSy
		   jmp      CIMA
CIMA:              
		   RET
PAREDECIMA endp

PAREDEBAIXO PROC
           mov      al, POSy
		   mov      CURPOSy, al
           inc      CURPOSy
		   goto_xy  POSx, CURPOSy
		   mov   	ah, 08h
		   mov		bh,0		
		   int		10h
		   mov		CARAUX, al	
		   ;mov		Cor, ah
		   cmp      CARAUX, 177
		   je       BAIXO 
		   inc      POSy
		   jmp      BAIXO
BAIXO:              
		   RET
PAREDEBAIXO endp

PAREDEDIREITA PROC
           mov      al, POSx
		   mov      CURPOSx, al
           inc      CURPOSx
		   goto_xy  CURPOSx, POSy
		   mov   	ah, 08h
		   mov		bh,0		
		   int		10h
		   mov		CARAUX, al	
		   ;mov		Cor, ah
		   cmp      CARAUX, 177
		   je       DIREITA 
		   inc      POSx
		   jmp      DIREITA
DIREITA:              
		   RET
PAREDEDIREITA endp

PAREDEESQUERDA PROC
           mov      al, POSx
		   mov      CURPOSx, al
           dec      CURPOSx
		   goto_xy  CURPOSx, POSy
		   mov   	ah, 08h
		   mov		bh,0		
		   int		10h
		   mov		CARAUX, al	
		   ;mov		Cor, ah
		   cmp      CARAUX, 177
		   je       ESQUERDA 
		   dec      POSx
		   jmp      ESQUERDA
ESQUERDA:              
		   RET
PAREDEESQUERDA endp

;########################################################################
Main  proc
		mov			ax, dseg
		mov			ds,ax

		mov			ax,0B800h
		mov			es,ax

        call		apaga_ecran
		goto_xy		0,0
		call 		AVATAR
		goto_xy     10,24

		mov			ah,4CH
		INT			21H
Main	endp
Cseg	ends
end	Main



