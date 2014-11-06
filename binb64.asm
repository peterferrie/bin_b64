bits 32

;No GetPC(), requires ESI=EIP

b64decode:
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
        jnb b64_testchar
        add al, (('/' << 2) + 1) & 0ffh
        shr al, 2 ;because '+' and '/' differ by only 1 bit

b64_testchar:
        add al, 4
        cmp al, 3fh
        jbe b64_store
        sub al, 45h
        cmp al, 19h
        jbe b64_store
        sub al, 6

b64_store:
        shrd ebx, eax, 6
        loop b64_inner
        xchg ebx, eax
        bswap eax
        stosd
        cmp byte [esi], '+'
        dec edi
        jnb b64_outer

b64decode_end:
        ;append your base64 data here
        ;terminate with printable character less than '+'
