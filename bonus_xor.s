	.global bonus_xor
	.p2align 2
	.type bonus_xor,%function

.data
.global xor_checksum
xor_checksum:
    .word 0
.text
bonus_xor:
		.fnstart
		push	{r4, lr}
		mov r4, r0				// Save input string to r4 to preserve it	
		bl strlen				// Get string length 
		mov r1, r0				// Store string length in r1
		mov r0, #0 				// Reset r0 to store XOR results
		mov r3, #0				// Initialize i=0
loop_start:
		cmp r3, r1				// if i > string length 
		bge function_end		// Go to function end
		
		ldrb r2, [r4, r3]		// Load character at index i
		eor r0, r0, r2			// XOR previously XOR'd characters with current
		add r3, r3, #1			// Increment i
		b loop_start		
function_end:
		ldr r1, =xor_checksum 	// Load global variable memory address
		str r0, [r1]			// Store result in global variable
		pop		{r4, lr}
		bx lr
		.fnend
		

		
