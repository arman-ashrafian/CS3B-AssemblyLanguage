// Arman Ashrafian
// CS 3B
// AW - 1

#include <iostream>
#include <string>
#include "math.h"

using namespace std;

string twosComp(string input) {
	// flip bits
	for(int i = 0; i < 16; i++) {
		if(input[i] == '1') { input[i] = '0'; }
		else { input[i] = '1'; }
	}

	// Add 1
	bool carry;
	int i = 14;
	if(input[15] == '1') {
		carry = true;
		input[15] = '0';
	} else {
		carry = false;
		input[15] = '1';
	}

	while(carry && i >= 0) {
		if(input[i] == '0') {
			input[i] = '1';
			carry = false;
		} else {
			input[i] = '0';
		}
		i--;
	}

	return input;
}

int valueOf(string input) {
	int value = 0;
	char signBit = input[0];
	int sign = 1;

	// neagative #
	if(signBit == '1') { 
		input = twosComp(input);
		sign = -1;
	}

	int exp = 15;
	// loop thru string backwards
	for(int i = 0; i < 16; i++) {
		if(input[i] == '1') {
			value += pow(2, exp);
		}
		exp--;
	}

	return value * sign;
}

int main() {

	cout << valueOf("1010101111001010") << endl;
	cout << valueOf("0011111111000011") << endl;
	cout << valueOf("1111111111111111") << endl;
	cout << valueOf("0000000000000000") << endl;
	cout << valueOf("1000000000000000") << endl;
	cout << valueOf("1000000000000001") << endl;
	cout << valueOf("0000000000000001") << endl;
	cout << valueOf("0000111100001111") << endl;
	cout << valueOf("0101010101010101") << endl;
	cout << valueOf("1010101010101010") << endl;

	return 0;
    
}