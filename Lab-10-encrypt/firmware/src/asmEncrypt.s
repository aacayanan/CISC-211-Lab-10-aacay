/*** asmEncrypt.s   ***/

#include <xc.h>

# Declare the following to be in data memory 
.data  

# Define the globals so that the C code can access them
# (in this lab we return the pointer, so strictly speaking,
# doesn't really need to be defined as global)
# .global cipherText
.type cipherText,%gnu_unique_object

.align
# space allocated for cipherText: 200 bytes, prefilled with 0x2A */
cipherText: .space 200,0x2A  
 
# Tell the assembler that what follows is in instruction memory    
.text
.align

# Tell the assembler to allow both 16b and 32b extended Thumb instructions
.syntax unified

    
/********************************************************************
function name: asmEncrypt
function description:
     pointerToCipherText = asmEncrypt ( ptrToInputText , key )
     
where:
     input:
     ptrToInputText: location of first character in null-terminated
                     input string. Per calling convention, passed in via r0.
     key:            shift value (K). Range 0-25. Passed in via r1.
     
     output:
     pointerToCipherText: mem location (address) of first character of
                          encrypted text. Returned in r0
     
     function description: asmEncrypt reads each character of an input
                           string, uses a shifted alphabet to encrypt it,
                           and stores the new character value in memory
                           location beginning at "cipherText". After copying
                           a character to cipherText, a pointer is incremented 
                           so that the next letter is stored in the bext byte.
                           Only encrypt characters in the range [a-zA-Z].
                           Any other characters should just be copied as-is
                           without modifications
                           Stop processing the input string when a NULL (0)
                           byte is reached. Make sure to add the NULL at the
                           end of the cipherText string.
     
     notes:
        The return value will always be the mem location defined by
        the label "cipherText".
     
     
********************************************************************/    
.global asmEncrypt
.type asmEncrypt,%function
asmEncrypt:   

    # save the caller's registers, as required by the ARM calling convention
    push {r4-r11,LR}
    
    /* YOUR asmEncrypt CODE BELOW THIS LINE! VVVVVVVVVVVVVVVVVVVVV  */
    
    /* load r1 */
    mov r5, r1
    /* load cypherText to r6 */
    ldr r6, =cipherText
encrypt_loop:
    /* load r0 */
    ldrb r4, [r0], #1
    
    /* check for null terminator */
    cmp r4, #0
    beq encrypt_done
    
    /* check if character is alphabetic (greater than 65) */
    cmp r4, #65
    blt store_character
    
add_shift_upper:
    add r4, r4, r1
    cmp r4, #90
    blt shift_upper
    
shift_upper:
    sub r4, r4, #90
    add r4, r4, #65
    b store_character

    
store_character:
    strb r4, [r6], #1
    b encrypt_loop
    
encrypt_done:
    ldr r0, =cipherText
    /* YOUR asmEncrypt CODE ABOVE THIS LINE! ^^^^^^^^^^^^^^^^^^^^^  */

    # restore the caller's registers, as required by the ARM calling convention
    pop {r4-r11,LR}

    mov pc, lr	 /* asmEncrypt return to caller */
   

/**********************************************************************/   
.end  /* The assembler will not process anything after this directive!!! */
           




