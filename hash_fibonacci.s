.global hash_fibonacci
.p2align 2
.type hash_fibonacci,%function

.data
.global fibonacci_asm
fibonacci_asm:
	.word 0
.text	
hash_fibonacci:
		.fnstart
		push {r4, lr}
		mov r4, r0 			// Save input to r4 so its saved to the stack during recursion
		cmp r0, #0			// if input = 0
		beq case_0			// Go to case 0
		cmp r0, #1			// if input = 1
		beq case_1			// Go to case 1
case_2:
		sub r0, r4, #1		// r0= n-1 (Input to first recursion)
		bl hash_fibonacci
		mov r1, r0			// Save first recursion output to r1
		sub r0, r4, #2		// r0= n-2 (Input to second recursion)
		push {r1}			// Save first recursion result to stack
		bl hash_fibonacci
		pop {r1}			// Retrieve first recursion result from stack
		add r0, r0, r1		// Add both recursion results
func_end:
		ldr r1, =fibonacci_asm	// Load global variable memory address
		str r0, [r1]		// Store output to global variable
		pop {r4, lr}
		bx 		lr
		.fnend
		
case_0:
		mov r0, #0			// Set function output to 0
		b func_end
		
case_1:
		mov r0, #1			// Set function ouput to 1
		b func_end
		

		
