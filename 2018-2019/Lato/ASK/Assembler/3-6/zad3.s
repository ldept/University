	.text
	.global	insert_sort
	.type	insert_sort, @function
insert_sort:
    mov %rsi, %rax
    sub %rdi, %rax  # rax = size of tab-1 (last-first)
   # imul $0x8, %rax
    
    mov $0x8, %r9     # i = 1
OL: # outer loop
    cmp %rax, %r9   # i <= n
    jg END
    mov %r9, %r10   # j = i
    sub $0x8, %r10    # j = j - 1
    mov (%r9,%rdi), %r11 # r11 = first[i]
IL: # inner loop    
    cmp $0x0, %r10 # j >= 0
    jl ILEND
    cmp %r11, (%r10,%rdi)     # first[j] > r11
    jle ILEND
    mov (%r10,%rdi), %rdx
    mov %rdx, 0x8(%r10,%rdi)
    # mov 0x8(%r10,%rdi), %rdx
    # mov (%r10,%rdi), %rdx     # first[j+1] = first[j]
    sub $0x8, %r10                # j - 1
    jmp IL
ILEND:
    mov %r11, 0x8(%r10,%rdi)  # first[j+1] = r11
    add $0x8, %r9                 # i++
    jmp OL
    
END:    
    ret

	.size	insert_sort, . - insert_sort
