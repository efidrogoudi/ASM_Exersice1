#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include "uart.h"

#define BAUD_RATE 115200



int num_hash[10] = {5, 12, 7, 6, 4, 11, 6, 3, 10, 23};
int a,b;

extern int hash_asm;
extern int mod_asm;
extern int fibonacci_asm;
extern int xor_checksum;

extern int hash_value(char *str);
extern int hash_mod(int value);
extern int hash_fibonacci(int n);
extern void bonus_xor(char *str);

void init_a_b(){
		a = 1;
		b = 2;
}

int hash_value2(char *str) {
	int hash=strlen(str);
	for(int i=0; i<(int)strlen(str); i++){
			if(str[i] >= 'A' && str[i] <= 'Z'){
					hash += (int)str[i]*2;
			}else if(str[i] >= 'a' && str[i] <= 'z') {
					hash += (int)((str[i] - 'a') * (str[i] - 'a')); 
			}else if(str[i] >= '0' && str[i] <= '9') {
					hash += num_hash[(str[i] - '0')];
			};
	};
	return hash;
};

int hash_mod2(int value) {
	int a=0;
	if(value > 9) {
		while(value>0){
			a += value % 10;
			value /= 10;
		};
		a = a%7;
		return a;
	};
	return value;
};

int fibonacci(int n) {
	if (n == 0)
			return 0;
	else if (n == 1)
		return 1;
	else
		return fibonacci(n-1) + fibonacci(n-2);
};

int xor_checksum2(const char *str) {
    int result = 0;

    while (*str != '\0') {
        result ^= *str;
        str++;
    }

    return result;
}


void uart_read_string(char *buffer, int max_length) {
    int i = 0;
    char c;

    while (i < max_length - 1) {
        c = uart_rx();
				uart_tx(c);
                    

        if (c == '\n' || c == '\r') {
            break;             
        }

        buffer[i++] = c;
    }

    buffer[i] = '\0';       
}


int main() {
		int hashC, hashS;
		int modC, modS;
		int fibC, fibS;
		int xorC;

		int check_hash, check_mod, check_fib, check_xor;
		int all_ok;
		uart_init(BAUD_RATE);
		uart_enable();
		while(1){
			char input[16];
			uart_print("Enter string:\r\n");
			uart_read_string(input, sizeof(input));
			uart_print("Received:\r\n");
			uart_print(input);
			uart_print("\r\n");

			hashC = hash_value2(input);
			hashS = hash_value(input);

			modC = hash_mod2(hashC);
			modS = hash_mod(hashS);

			fibC = fibonacci(modC);
			fibS = hash_fibonacci(modS);
			
			bonus_xor(input);
			xorC = xor_checksum2(input);

			check_hash = (hashC == hash_asm) && (hash_asm == hashS);
			check_mod  = (modC == mod_asm) && (mod_asm == modS);
			check_fib  = (fibC == fibonacci_asm) && (fibonacci_asm == fibS);
			check_xor  = (xorC == xor_checksum);

			all_ok = check_hash && check_mod && check_fib && check_xor;

			printf("Input: %s\n", input);

			printf("  HashC: %d | HashS: %d | hash_asm: %d | Match: %d\n", hashC, hashS, hash_asm, check_hash);
			printf("   ModC: %d | ModS: %d | mod_asm: %d | Match: %d\n", modC, modS, mod_asm, check_mod);
			printf("   FibC: %d | FibS: %d | fibonacci_asm: %d | Match: %d\n", fibC, fibS, fibonacci_asm, check_fib);
			printf("   xorC: %d | xorS: %d | xor_checksum: %d | Match: %d\n", xorC, xor_checksum, xor_checksum, check_xor);

			printf("Final Check: %d\n\n", all_ok);
		};

	return 0;
}
