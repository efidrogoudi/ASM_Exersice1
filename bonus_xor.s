	.global bonus_xor
	.p2align 2
	.type bonus_xor,%function

	
bonus_xor:
		.fnstart
		push	{r4, r5, lr}
		mov r4, r0
		
		bl strlen
		mov r1, r0
		mov r5, #0 
		
		mov r3, #0
		b loop_start
		
loop_end:
		ldr r1, =xor_checksum
		str r5, [r1]
		pop		{r4, r5, lr}
		bx lr
		.fnend
		
loop_start:
		cmp r3, r1
		bge loop_end
		
		ldrb r2, [r4, r3]
		eor r5, r5, r2
		add r3, r3, #1
		b loop_start
		
	.data
    .global xor_checksum
xor_checksum:
    .word 0