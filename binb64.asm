bits 32

;No GetPC(), requires ESI=EIP

_b64decode:
        add esi, b64decode_end - _b64decode
        push esi
        pop edi

b64_outer:
        push 4
        lodsd
        pop ecx

b64_inner:
        rol eax, 8
        cmp al, '0'
        jnb b64_testupr
	shr al, 2 ;because '+' and '/' differ by only 1 bit
        add al, '0' ;concatenate numbers and '+' and '/'

b64_testupr:
        cmp al, 'A'
        jnb b64_testlwr
        add al, ('z' + 1) - '0' ;concatenate lowercase and numbers

b64_testlwr:
        cmp al, 'a'
        jb b64_store
        sub al, 'a' - ('Z' + 1) ;concatenate uppercase and lowercase

b64_store:
        sub al, 'A'
        shrd ebx, eax, 6
        loop b64_inner
        bswap ebx
        xchg ebx, eax
        stosd
        cmp byte [esi], '+'
        dec edi
        jnb b64_outer

b64decode_end:
        ;append your base64 data here
        ;terminate with printable character less than '+'
