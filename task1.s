.data
    n: .space 4
    nr: .space 4
    d: .space 1
    pr: .long 0
    p: .long 0
    u: .long 0
    ult: .long 0
    size: .space 4
    instr: .space 4
    memory: .space 1024
    formatString: .asciz "%ld"
    byteformatString: .asciz "%d"
    addOutput: .asciz "%d: (%d, %d)\n"
    getOutput: .asciz "(%d, %d)\n"
    noSpaceMsg: .asciz "%d: (0, 0)\n"
    nothing: .asciz "(0, 0)\n"
    debugMsg: .asciz "SUNT AICI %d\n"
    debugMsg2: .asciz "%d "

.text
    FADD:
        lea memory, %edi 
        ;// citeste nr
        pushl $nr
        pushl $formatString
        call scanf
        addl $8, %esp
        LOOP_ADD:
            movl nr, %eax
            cmpl $0, %eax
            je fexit

            pushl $d
            pushl $byteformatString
            call scanf
            popl %ebx
            popl %ebx

            pushl $size
            pushl $formatString
            call scanf
            popl %ebx
            popl %ebx

            subl $1, nr
            

            xorl %edx, %edx
            movl size, %eax
            movl $8, %ecx
            divl %ecx

            movl %eax, size

            movl $0,%ecx


            cmpl $0, %edx
            je find_loop_fst

            addl $1, size
        find_loop_fst:
            cmpl $1024, %ecx
            je afisare_nimic
            movl $0, %eax
            movb (%edi,%ecx,1), %al
            cmp $0, %eax
            je prima
            addl $1,%ecx
            jmp find_loop_fst
        prima:
            movl %ecx, pr
        find_loop_last:
            cmpl $1024, %ecx
            je check_afisare
            movl $0, %eax
            movb (%edi,%ecx,1), %al
            cmp $0 ,%eax
            jne check_afisare
            addl $1,%ecx
            jmp find_loop_last
        check_afisare:
            movl %ecx, %eax
            subl $1, %ecx
            movl %ecx, ult
            subl pr,%eax
            cmpl %eax,size
            jbe add_ult
            cmpl $1024, %ecx
            je afisare_nimic
            movl pr, %ecx
            addl $1, %ecx
            jmp find_loop_fst
        add_ult:
            movl pr, %eax
            addl size, %eax
            movl %eax, ult
            movl %eax, %ecx
        add_loop:
            subl $1, %ecx
            movb d, %al
            movb %al,(%edi,%ecx,1)

            cmpl pr, %ecx
            jne add_loop
        afisare:
            subl $1, ult
            pushl ult
            pushl pr
            xorl %eax,%eax
            movb d, %al
            pushl %eax
            pushl $addOutput
            call printf
            popl %ebx
            popl %ebx
            popl %ebx
            popl %ebx

            pushl $0
            call fflush
            popl %ebx

            jmp LOOP_ADD
        afisare_nimic:
            xorl %eax,%eax
            movb d, %al
            pushl %eax
            pushl $noSpaceMsg
            call printf
            popl %ebx
            popl %ebx

            pushl $0
            call fflush
            popl %ebx
            jmp LOOP_ADD
        fexit:
            ret
    FGET:
        pushl $d
        pushl $byteformatString
        call scanf
        popl %ebx
        popl %ebx

        movl $0, %ebx
        movl %ebx, pr
        movl %ebx, ult
        prloop:
            cmpl $1024, %ebx
            je noafis
            mov (%edi,%ebx,1), %al
            cmpb d, %al
            je pratr
            addl $1, %ebx
            jmp prloop
        pratr:
            movl %ebx, pr
        ultloop:
            mov (%edi,%ebx,1), %al
            cmpb d, %al
            jne getafis
            addl $1, %ebx
            jmp ultloop
        getafis:
            movl %ebx, ult
            subl $1, ult
            pushl ult
            pushl pr
            pushl $getOutput
            call printf
            popl %ebx
            popl %ebx
            popl %ebx

            pushl $0
            call fflush
            popl %ebx
            jmp getexit
        noafis:
            pushl $nothing
            call printf
            popl %ebx

            pushl $0
            call fflush
            popl %ebx
        getexit:
            ret
    FDELETE:
        lea memory, %edi
        pushl $d
        pushl $byteformatString
        call scanf
        popl %ebx
        popl %ebx
        movl $0, %ebx
        movl %ebx, p
        delloop:
            cmpl $1024, %ebx
            jge delexit
        delcheck:
            xorl %edx, %edx
            movb (%edi,%ebx,1), %dl

            xorl %eax,%eax
            movb (%edi,%ebx,1), %al

            cmpb d, %al
            je egal
        diferit:
            difloop:
                cmpl $1024, %ebx
                jge difloopexit
                xorl %eax,%eax
                movb (%edi,%ebx,1), %al 

                cmpb %dl,%al
                jne difloopexit
                addl $1, %ebx
                jmp difloop
            difloopexit:
                cmpl $0, %edx
                jne difloopcheck

                cmpl $1024, %ebx
                je delexit

                movl %ebx, p
                jmp delloop
            difloopcheck:
                subl $1,%ebx
                movl p, %eax

                pushl %ebx
                pushl %eax
                pushl %edx
                pushl $addOutput
                call printf
                popl %ecx
                popl %ecx
                popl %ecx
                popl %ecx

                pushl $0
                call fflush
                popl %ecx

                addl $1, %ebx
                movl %ebx,p
                jmp delloop
        egal:
            egalloop:
                cmpl $1024, %ebx
                jge delexit

                xorl %eax,%eax
                movb (%edi,%ebx,1), %al 

                cmp %dl,%al
                jne egalloopexit

                xorb %al, %al
                movb %al, (%edi,%ebx,1)
                addl $1, %ebx
                jmp egalloop
            egalloopexit:
                movl %ebx, p
                jmp delloop
        delexit:
            ret
    FDEFRAGMENTATION:
        movl $0, %ebx
        movl $0, %ecx
        readloop:
            cmpl $1024, %ebx
            je nimic
            xorl %eax, %eax
            movb (%edi,%ebx,1), %al
            cmpl $0, %eax
            je defr
            movb %al, (%edi,%ecx,1)
            addl $1, %ecx
            addl $1, %ebx
            jmp readloop
        defr:
            addl $1, %ebx
            jmp readloop
        nimic:
            cmpl $1024,%ecx
            je defafis
        rest:
            cmpl $1024, %ecx
            je defafis
            movb $0, (%edi,%ecx,1)
            addl $1, %ecx
            mov $0, %ebx
            jmp rest
        defafis:
            movl $0, %ebx
            movl %ebx, p
            defloop:
                cmpl $1024, %ebx
                jge defexit
                xorl %edx, %edx
                movb (%edi,%ebx,1), %dl
                cmpl $0, %edx
                je defexit
            pozitii:
                cmpl $1024, %ebx
                jge defafisari
                xorl %eax,%eax
                movb (%edi,%ebx,1), %al 

                cmpb %dl,%al
                jne defafisari

                cmp $0, %edx
                je afisnimic

                addl $1, %ebx
                jmp pozitii
            defafisari:
                subl $1,%ebx
                movl p, %eax

                pushl %ebx
                pushl %eax
                pushl %edx
                pushl $addOutput
                call printf
                popl %ecx
                popl %ecx
                popl %ecx
                popl %ecx
                
                pushl $0
                call fflush
                popl %ecx

                addl $1, %ebx
                movl %ebx,p
                jmp defloop
        afisnimic:
            pushl $nothing
            call printf
            pushl %ecx
        defexit:
            ret

    FAFIS:
        movl $0, %ebx
        loop:
            cmpl $1024, %ebx
            je fexitafis

            xorl %edx, %edx
            movb (%edi,%ebx,1), %dl
            pushl %edx
            pushl $debugMsg2
            call printf
            popl %eax
            popl %eax

            addl $1, %ebx
            jmp loop
        fexitafis:
            ret

.global main
main:
    pushl $n
    pushl $formatString
    call scanf
    popl %ebx
    popl %ebx

    lea memory, %edi
instructiuni:
    movl n, %eax
    cmpl $0, %eax
    je  etexit 

    subl $1, n

    pushl $instr
    pushl $formatString
    call scanf
    popl %ebx
    popl %ebx

    cmpl $1, instr 
    je ADD

    cmpl $2, instr
    je GET

    cmpl $3, instr
    je DELETE

    cmpl $4, instr
    je DEFRAGMENTATION

ADD:
    call FADD
    jmp instructiuni
GET:
    call FGET
    jmp instructiuni
DELETE:
    call FDELETE
    jmp instructiuni
DEFRAGMENTATION:
    call FDEFRAGMENTATION
    jmp instructiuni
etexit:
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80
