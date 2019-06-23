	.text
	.global	clz
	.type	clz, @function
	
	#idea: w rax jest licznik ((1) maks moze byc 64 zer)
	#przesuwamy nasza liczbe w prawo
	#(dzielenie przez 2^i, i=5,4,3,2,1,0).
	#Jesli sie przez to wyzerowala
	#to albo za duzo podzielilismy, albo
	#juz jest koniec.
	#Jesli nie, to od licznika odejmujemy 2^i, bo
	#skoro sie nie wyzerowala to nie bylo tam zadnych
	#zer wiodacych.
	#Na koniec w rax jest liczba zer wiodacych.
clz:
    mov %rdi, %rsi
    mov $64, %rax   #(1) dlatego tutaj 64

    shr $32,%rsi
    cmp $0 ,%rsi
    je L16_r        #etykiety L*_r oznaczaja reset -
    mov %rsi, %rdi  #ustawiamy na poczatkowa wartosc, bo
    sub $32,%rax    #moglo sie wyzerowac cos co nie powinno
    jmp L16
    
L16_r:
    mov %rdi, %rsi
L16:                
    shr $16,%rsi
    cmp $0, %rsi
    je L8_r
    mov %rsi, %rdi
    sub $16,%rax
    jmp L8
L8_r:
    mov %rdi, %rsi
L8:
    shr $8, %rsi
    cmp $0, %rsi
    je L4_r
    mov %rsi, %rdi
    sub $8, %rax
    jmp L4
L4_r:
    mov %rdi, %rsi
L4:
    shr $4, %rsi
    cmp $0, %rsi
    je L2_r
    mov %rsi, %rdi
    sub $4, %rax
    jmp L2
L2_r:
    mov %rdi, %rsi
L2:
    shr $2, %rsi
    cmp $0, %rsi
    je L1_r
    mov %rsi, %rdi
    sub $2, %rax
    jmp L1
L1_r:
    mov %rdi, %rsi
L1:
    shr $1, %rsi
    cmp $0, %rsi
    je L0
    sub $2, %rax    #rax-2, bo nie wyzerowalo sie po
    ret             #przesunieciu, czyli odejmujemy dwa miejsca
L0:                 #niezerowe i przesuniete
    sub %rdi, %rax
    ret

	.size	clz, .-clz
