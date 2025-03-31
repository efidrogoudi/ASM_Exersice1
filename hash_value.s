	.global hash_value
	.p2align 2
	.type hash_value,%function
	.extern num_hash
hash_value:
		.fnstart
		push    {r4-r8, lr}    

		// r0 = str
		mov r4, r0 					
		// r0 = str, r1 = str
		bl strlen					
		// r0 = strlen(str), r1 = str
		mov r1, r4
		mov r2, r0 //length for hash value					
		// r0 = strlen(str), r1 = str, r2 = strlen(str)
		mov r3, #0 //i value
		// r0 = strlen(str), r1 = str, r2 = strlen(str), r3 = 0
		b loop_start
loop_end:
		ldr r1, =hash_asm
		str r0, [r1]
		pop     {r4-r8, lr}
		bx      lr
		
		.fnend

loop_start:
		cmp r3, r2
		bge loop_end
		
		ldrb r4, [r1, r3] // r4 = str[i] (r1 = str, r3 = i)
		cmp r4, #'A'
		blt check_number //if r4 < 'A' check for number
		cmp r4, #'Z'
		bgt check_lowercase //if r4 > 'Z' check lowercase
		b case_capital

loop_continue:		
		add r3, r3, #1
		b loop_start

check_number:
		cmp r4, #'0'
		blt loop_continue
		cmp r4, #'9'
		bgt loop_continue
		b case_number
		
check_lowercase:
		cmp r4, #'a'
		blt loop_continue
		cmp r4, #'z'
		bgt loop_continue
		b case_lowercase

case_capital:
		lsl r5, r4, #1 //r5=2*r4
		add r0, r0, r5 //add it to the hash
		b loop_continue

case_number:
		sub r6, r4, #'0' // Subtract ascii 0 from ascii number ('0'=48, '9'=57) 
		ldr r7, =num_hash // load array address from memory
		ldr r6, [r7, r6, LSL#2] // get content of array at address r7, at index r6 in increments of 4 bytes "LSL#2" 
		add r0, r0, r6
		b loop_continue
case_lowercase:
		sub r8, r4, #'a'
		mul r8, r8, r8
		add r0, r0, r8
		b loop_continue

		.data
		.global hash_asm
hash_asm:
	.word 0
	



		