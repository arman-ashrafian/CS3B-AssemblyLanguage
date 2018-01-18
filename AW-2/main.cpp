// Arman Ashrafian
// CS 3B
// AW - 2

#include <iostream>
#include <string>
#include <map>
#include "math.h"

using namespace std;

map<char, string> hex_map =
{
    {'0', "0000"},
    {'1', "0001"},
    {'2', "0010"},
    {'3', "0011"},
    {'4', "0100"},
    {'5', "0101"},
    {'6', "0110"},
    {'7', "0111"},
    {'8', "1000"},
    {'9', "1001"},
    {'A', "1010"},
    {'B', "1011"},
    {'C', "1100"},
    {'D', "1101"},
    {'E', "1110"},
    {'F', "1111"},
};

string hexToBinary(string input) {
    string output;

    for(char c : input) {
        output += hex_map[c];
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