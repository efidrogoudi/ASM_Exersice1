.global hash_mod
.p2align 2
.type hash_mod,%function

.data
.global mod_asm
mod_asm:
	.word 0
		
.text
hash_mod:
		.fnstart
		push	{lr}
		mov r1, #0 			// Initialize r1=0 (This will be used for mod result)

		cmp r0, #9			// if hash_value > 9
		blt func_end		// Go to function end			
add_loop:
		cmp r0, #0			// While r0=value > 0
		ble mod_calc		// (if value > 0)
		mov r2, #10 		// Set divider that isn't power of 2


		udiv r3, r0, r2 	// r3 = r0 / 10(r2)
		mul r3, r3, r2 		// r3 = r3 * 10(r2)
		sub r3, r0, r3 		// r3 = value % 10
		add r1, r1, r3 		// r1 += value % 10; 
		udiv r0, r0, r2 	// r0 = r0 / 10(r2)
		b add_loop
		
mod_calc:
		mov r2, #7 			// Set divider that isn't power of 2
		udiv r3, r1, r2 	// r3 = r1 / 7(r2)
		mul r3, r3, r2 		// r3 = r3 * 7(r2)
		sub r0, r1, r3 		// r0 = a % 7
func_end:	
		ldr r1, =mod_asm
		str r0, [r1]
		pop		{lr}
		bx lr
		.fnend
		

		
		