bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fread, fclose, printf, fprintf, fscanf             ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import fopen msvcrt.dll 
import fread msvcrt.dll
import fclose msvcrt.dll 
import printf msvcrt.dll
import fprintf msvcrt.dll
import fscanf msvcrt.dll                        ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    ;A file name try.txt is given in data segment.
    ;The file try exists and contains 10 numbers in hexadecimal.
    ;Extract the maximum number and print this maximum into another file try2. The file try2 doesn’t exist (it is necessary to be created first).
    file_name1 db "input.txt", 0 
    file_name2 db "output.txt", 0
    access_mode1 db "r", 0
    write_mode db "w", 0
    file_descriptor1 dd -1
    file_descriptor2 resd 1
    
    format_read db '%x', 0
    format_res db '%x ', 0
    
    maximum resd 0
    a dd 0
   aux dd 0



; our code starts here
segment code use32 class=code
    start:
        ; ...
        ;fopen()
        push dword access_mode1
        push dword file_name1
        call [fopen]
        add esp, 4*2
        
        mov [file_descriptor1], eax
        
        ;check if fopen() has succesfully created the file
        cmp eax, 0
        je final
        
        push dword a 
        push dword format_read
        push dword[file_descriptor1]
        call [fscanf]
        add esp, 4*3
        
        mov ebx, dword[a]
        mov [maximum], ebx
        mov ecx, 9
        
        myrepeat:
            mov [aux], ecx
            push dword a 
            push dword format_read
            push dword[file_descriptor1]
            call [fscanf]
            add esp, 4*3
            mov ebx, dword[a]
            cmp ebx, [maximum]
            jg greater
            jl less
                greater:
                    mov [maximum], ebx
                    jmp myendif
                less:
                myendif:
            mov ecx, [aux]
         loop myrepeat
        
        ;fprint 
        push dword write_mode
        push dword file_name2
        call [fopen]
        add esp, 4*2
        
        mov [file_descriptor2], eax
        
        push dword[maximum]
        push dword format_res
        push dword [file_descriptor2]
        call [fprintf]
        add esp, 4*3
        
        ;fclose  close
        push dword[file_descriptor2]
        call[fclose]
        add esp, 4*1
       
       
        push dword[file_descriptor1]
        call[fclose]
        add esp, 4*1
        
        final:
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
