// Arman Ashrafian
// CS 3B
// AW - 2

#include <iostream>
#include <string>
#include <map>
#include "math.h"

using namespace std;

string hexToBinary(string input) {
    string output;
	map<char, string> hex_map;
	
	hex_map['0'] = "0000";
	hex_map['1'] = "0001";
	hex_map['2'] = "0010";
	hex_map['3'] = "0011";
	hex_map['4'] = "0100";
	hex_map['5'] = "0101";
	hex_map['6'] = "0110";
	hex_map['7'] = "0111";
	hex_map['8'] = "1000";
	hex_map['9'] = "1001";
	hex_map['A'] = "1010";
	hex_map['B'] = "1011";
	hex_map['C'] = "1100";
	hex_map['D'] = "1101";
	hex_map['E'] = "1110";
	hex_map['F'] = "1111";


	for(int i = 0; i < input.size(); i++) {
		output += hex_map[input[i]];
	}

    return output;
}

string twosComp(string input) {
	// flip bits
	for(int i = 0; i < 32; i++) {
		if(input[i] == '1') { input[i] = '0'; }
		else { input[i] = '1'; }
	}

	// Add 1
	bool carry;
	int i = 30;
	if(input[31] == '1') {
		carry = true;
		input[31] = '0';
	} else {
		carry = false;
		input[31] = '1';
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

	int exp = 31;
	// loop thru string backwards
	for(int i = 0; i < 32; i++) {
		if(input[i] == '1') {
			value += pow(2, exp);
		}
		exp--;
	}

	return value * sign;
}


int main() {

    string bin = hexToBinary("ABCD0000");
    cout << "Binary  : " << bin << endl;

    int dec = valueOf(bin);
    cout << "Decimal : " << dec << endl;

    return 0;
}