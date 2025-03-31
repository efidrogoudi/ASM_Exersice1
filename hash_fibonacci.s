	.global hash_fibonacci
	.p2align 2
	.type hash_fibonacci,%function
		
hash_fibonacci:
		.fnstart
		push {r4, lr}
		
		
		mov r4, r0 // int n = r4
		cmp r0, #0
		beq case_0
		cmp r0, #1
		beq case_1
		b case_2
func_end:
		ldr r1, =fibonacci_asm
		str r0, [r1]
		pop {r4, lr}
		bx 		lr
		.fnend
		
case_0:
		mov r0, #0
		b func_end
		
case_1:
		mov r0, #1
		b func_end
		
case_2:
		sub r0, r4, #1
		push {r4}
		bl hash_fibonacci
		pop {r4} 
		mov r1, r0
		sub r0, r4, #2
		push {r1}
		bl hash_fibonacci
		pop {r1}
		add r0, r0, r1
		b func_end
		
		.data
		.global fibonacci_asm
fibonacci_asm:
	.word 0