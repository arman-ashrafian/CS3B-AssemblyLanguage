// Arman Ashrafian
// CS 3B
// AW - 1

#include <iostream>
#include <string>
#include "math.h"

using namespace std;

string twosComp(string input) {
	for(int i = 0; i < 16; i++) {
		if(input[i] == '1') { input[i] = '0'; }
		else { input[i] = '1'; }
	}
	
	// Add 1
	int i = 15;
	int carry = 1;
	while(carry != 0) {
		if(input[i] == '0') { 
			input[i] = '1';
			carry = 0;
		} else {
			carry = 1;
		}
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
		cout << "TWOCOMP: " << input << endl;
	}

	int exp = 14;
	// loop thru string backwards
	for(int i = 1; i < 16; i++) {
		if(input[i] == '1') {
			value += pow(2, exp);
		}
		exp--;
	}

	return value * sign;
}

int main() {

	string input;
	getline(cin, input);
	cout << valueOf(input) << "\n";

	return 0;
    
}