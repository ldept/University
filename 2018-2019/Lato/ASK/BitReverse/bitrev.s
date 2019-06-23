	.text
	.global	bitrev
	.type	bitrev, @function
bitrev:
    mov %rdi,%rax
    
    #idea: tworze maski, zamieniam najpierw kazde
    #dwa bity obok siebie, 
    #potem zamieniam te zmienione dwojki,
    #potem czworki itd. (jak na cwiczeniach)
    
    #dla wszystkich "kawalkow" programu:
    #w rdx maska na "pierwsze" bity
    #(od pierwszego bitu, pierwszej dwojki, czworki itd.)
    #w rsi maska na "dalsze" bity
    #(analogicznie)
    
    
    
    #zamienianie dwoch bitow obok 10011011 -> 01100111
    mov $0xAAAAAAAAAAAAAAAA, %rdx
    mov $0x5555555555555555, %rsi
    and %rax, %rdx
    and %rsi, %rax
    shl $1  , %rax
    shr $1  , %rdx
    or  %rdx, %rax

    #dwoch dwojek 01100111 -> 10011101 
    mov $0xCCCCCCCCCCCCCCCC, %rdx
    mov $0x3333333333333333, %rsi
    and %rax, %rdx
    and %rsi, %rax
    shl $2  , %rax
    shr $2  , %rdx
    or  %rdx, %rax
    
    #czworek 10011101 -> 11011001
    #(dla jednego bitu z przykladu to juz jest odwrocenie)
    mov $0xF0F0F0F0F0F0F0F0, %rdx
    mov $0x0F0F0F0F0F0F0F0F, %rsi
    and %rax, %rdx
    and %rsi, %rax
    shl $4  , %rax
    shr $4  , %rdx
    or  %rdx, %rax
    
    #itd.
    mov $0xFF00FF00FF00FF00, %rdx
    mov $0x00FF00FF00FF00FF, %rsi
    and %rax, %rdx
    and %rsi, %rax
    shl $8  , %rax
    shr $8  , %rdx
    or  %rdx, %rax

    mov $0xFFFF0000FFFF0000, %rdx
    mov $0x0000FFFF0000FFFF, %rsi
    and %rax, %rdx
    and %rsi, %rax
    shl $16 , %rax    
    shr $16 , %rdx
    or  %rdx, %rax

    mov $0xFFFFFFFF00000000, %rdx
    mov $0x00000000FFFFFFFF, %rsi
    and %rax, %rdx
    and %rsi, %rax
    shl $32 , %rax    
    shr $32 , %rdx
    or  %rdx, %rax
    ret

	.size	bitrev, .-bitrev