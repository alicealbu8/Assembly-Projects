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
import fscanf msvcrt.dll                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    ;A string of doublewords is given in data segment.
    ;Extract only the doublewords with an odd numbers of bits equal to 1 and print this string in file try3. The file try3 doesn’t exist (it is necessary to be created first).
    s dd 22, 15, 1 ;result is 22, 1 
    lens equ($-s)/4
    file_name2 db "output.txt", 0
    write_mode db "w", 0
    d resd lens
    suma dd 0
    format db'%d ', 0
    formatrez db '%d ', 0
    noofelements dd 0
    file_descriptor2 dd -1
    copie dd 0
    aux dd 0
    aux2 dd 0

; our code starts here
segment code use32 class=code
    start:
        ; ...
        
        mov edi,0
        mov ebp,0
        mov esi,0
        mov ecx, lens
        
        myrepeat:;loop for doublewords 
        
            mov dword[suma], 0;for each dword the sum starts again from 0
            mov [aux], ecx;copy of ecx
            mov edx, dword[s+ebp];copy of the quadword 
            mov ecx, 4;4 bytes in a dword 
           
            myrepeatBytes:
            mov al, byte[s+esi]
            mov [aux2], ecx; second copy of ecx 
            mov ecx, 8
            myrepeatbits:
            shr al, 1 
            jc equal;if carry flag is 1 
            jnc notequal;if carry flag = 0    
                equal:
                inc dword[suma]
                notequal:
            loop myrepeatbits
            inc esi
            mov ecx, [aux2]
            
        loop myrepeatBytes
            
            
            mov ecx, edx ; we will need edx for division->why we need the first copy of eax 
            mov eax, [suma]
            cdq 
            mov ebx, 2
            div ebx
            cmp edx,0
            jne addInD
            je next
                addInD:
                    mov dword[edi+d], ecx
                    add edi, 4
                    add dword[noofelements], 1 
                next:
            add ebp, 4
            mov ecx, [aux]
            
        loop myrepeat
        
        mov ecx, dword[noofelements]
        mov esi, 0
        myrepeatprint:
                mov eax, dword[d+esi]
                mov dword[copie], ecx
                push eax 
                push dword format
                call [printf]
                add esp, 4*2
                mov ecx, [copie]
                add esi, 4
        loop myrepeatprint
        
         ;fprint 
        push dword write_mode
        push dword file_name2
        call [fopen]
        add esp, 4*2
        
        mov [file_descriptor2], eax
        
        mov ecx, dword[noofelements]
        mov esi, 0
        myrepeatPrintFile:
             mov eax, dword[d+esi]
             mov dword[copie], ecx
             push eax 
             push dword format
             push dword [file_descriptor2]
             call [fprintf]
             add esp, 4*3
             mov ecx, [copie]
             add esi, 4
        loop myrepeatPrintFile
       
        
         ;fclose  close
        push dword[file_descriptor2]
        call[fclose]
        add esp, 4*1
        
  
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
