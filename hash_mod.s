	.global hash_mod
	.p2align 2
	.type hash_mod,%function
	
hash_mod:
		.fnstart
		push	{r4-r7, lr}
		
		mov r4, r0 // r0=value, r4=value
		mov r1, #0 //r1=0
		
		cmp r4, #9
		blt func_end
		b add_loop
				
func_end:	
		mov r0,r4
		ldr r1, =mod_asm
		str r0, [r1]
		pop		{r4-r7, lr}
		bx lr
		.fnend
		
add_loop:
		cmp r4, #0
		ble mod_calc
		mov r2, #10 //r2=10
		//Calculation of the mod
		udiv r3, r4, r2 // r3 = r4 / 10(r2)
		mul r3, r3, r2 // r3 = r3 * 10(r2)
		sub r5, r4, r3 // r5 = value % 10
		add r1, r1, r5 // a(r1) += value % 10; 
		udiv r4, r4, r2 // r4 = r4 / 10(r2)
		b add_loop
		
mod_calc:
		mov r6, #7 //r6 = 7
		udiv r3, r1, r6 // r3 = r1(a) / 7(r6)
		mul r3, r3, r6 // r3 = r3 * 7(r6)
		sub r7, r1, r3 // r7 = a % 7
		mov r4, r7
		b func_end
		
		.data
		.global mod_asm
mod_asm:
	.word 0
		
		