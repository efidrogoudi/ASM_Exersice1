.global hash_value
.p2align 2
.type hash_value,%function
.extern strlen

.data
.global hash_asm
hash_asm:
	.word 0
DIGIT_TABLE:
    .word 5, 12, 7, 6, 4, 11, 6, 3, 10, 23  // The given values for digits 0-9

.text
hash_value:
		.fnstart	
		push    {r4-r5, lr}    
	
		mov r4, r0 					// Save input string to r4 so we can call strlen
		bl strlen 					// Get string length in r0
		mov r1, r0					// Save sring length in r1
		mov r2, #0					// Initialize r2 as i = 0
		ldr r3, =DIGIT_TABLE		// Load DIGIT_TABLE address from memory
loop_start:
		cmp r2,r1					// if r2=i >= r1=strlen
		bge function_end			// Go to function_end
		ldrb r5, [r4, r2] 			// Load a byte from input string array r5=str[i]
		add r2, r2, #1				// Increment i (r2++)
		cmp r5, #'A'				// if r5=str[i] < 'A'
		blt case_number				// Go to check number
		cmp r5, #'Z'				// if r5=str[i] > 'Z'
		bgt case_lowercase			// Go to check lowercase
case_capital:
		lsl r5, r5, #1				// r5=str[i] -> r5=r5*2
		add r0, r0, r5				// Add the result of str[i]^2 to the hash result (r0)
		b loop_start
case_number:
		cmp r5, #'0'				// if r5=str[i] < '0'
		blt loop_start				// Go to loop start (No acceptable ASCII less than 0)
		cmp r5, #'9'				// if r5=str[i] > '9'
		bgt loop_start				// Go to loop start  (No accpetable ACCI more than 9 & less than A)
		sub r5, r5, #'0'			// Get int value of str[i] if its a number (ASCII[int] - ASCII[0]) 
		ldr r5, [r3, r5, LSL#2]		// Get DIGIT_TABLE[r5=(int)str[i]] 
		add r0, r0, r5				// Add the new hash value to the result
		b loop_start
case_lowercase:
		cmp r5, #'a'				// if r5=str[i] < 'a'
		blt loop_start				// Go to loop start (No acceptable ASCII more than Z & less than a)
		cmp r5, #'z'				// if r5=str[i] > 'z'
		bgt loop_start				// Go to loop start (No acceptable ASCII more than z)
		sub r5, r5, #'a'			// Get int value of str[i]
		mul r5, r5, r5				// Square it  -> str[i]^2
		add r0, r0, r5				// Add it to the result
		b loop_start
		
function_end:
		ldr r1, =hash_asm  
		str r0, [r1]
		pop     {r4-r5, lr}
		bx      lr
	.fnend


		