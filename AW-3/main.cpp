// Arman Ashrafian
// CS 3B
// AW - 3
// 1-25-2018

// Convert signed integer to hex

#include <iostream>
#include <string>
#include <sstream>
#include <map>
#include "math.h"

using namespace std;

string intToString(int number)
{
  std::ostringstream oss;
  oss<< number;
  return oss.str();
}

void flipBits(string &in) {
    string out;

    for(int i = 0; i < in.size(); i++) {
        if(in[i] == '1') { in[i] = '0'; }
        else { in[i] = '1'; }
        }
}

string intToBinary(int num) {
    string out;

    // positive
    if(num >= 0) {
        int rem;
        do {
            rem = num % 2;
            out = intToString(rem) + out;
            num = num / 2;
        } while(num != 0);

        // ensure 32 bits
        while(out.size() < 32) {
            out = "0" + out;
    }
    }
    // negative
    else {
        // get positive binary
        string bits = intToBinary(num * -1);

        // flip bits
        flipBits(bits);

        // + 1
        bool carry;
        int i = bits.size() - 2;
        if(bits[i + 1] == '1') {
            carry = true;
            bits[i + 1] = '0';
        } else {
            carry = false;
            bits[i + 1] = '1';
        }

        while(carry && i >= 0) {
            if(bits[i] == '0') {
                bits[i] = '1';
                carry = false;
            } else {
                bits[i] = '0';
            }
            i--;
        }

        out = bits;
    }

    return out;
}

string binToHex(string bin) {
    string out;
    map<string, char> hexMap;

    hexMap["0000"] = '0';
    hexMap["0001"] = '1';
    hexMap["0010"] = '2';
    hexMap["0011"] = '3';
    hexMap["0100"] = '4';
    hexMap["0101"] = '5';
    hexMap["0110"] = '6';
    hexMap["0111"] = '7';
    hexMap["1000"] = '8';
    hexMap["1001"] = '9';
    hexMap["1010"] = 'a';
    hexMap["1011"] = 'b';
    hexMap["1100"] = 'c';
    hexMap["1101"] = 'd';
    hexMap["1110"] = 'e';
    hexMap["1111"] = 'f';

    for(int i = 0; i < bin.size(); i+=4) {
        out += hexMap[bin.substr(i, 4)];
    }

    return out;
}

int main() {

    cout << "          0 = " << binToHex(intToBinary(0)) << 'h' << endl;
    cout << "         -1 = " << binToHex(intToBinary(-1)) << 'h' << endl;
    cout << "    1000000 = " << binToHex(intToBinary(1000000)) << 'h' << endl;
    cout << " 2147483647 = " << binToHex(intToBinary(2147483647)) << 'h' << endl;
    // cout << "-2147483648 = " << binToHex(intToBinary(-2147483648)) << 'h' << endl;
    cout << "  268435456 = " << binToHex(intToBinary(268435456)) << 'h' << endl;
    cout << "   16777216 = " << binToHex(intToBinary(16777216)) << 'h' << endl;
    cout << "    1048576 = " << binToHex(intToBinary(1048576)) << 'h' << endl;
    cout << "      65536 = " << binToHex(intToBinary(65536)) << 'h' << endl;
    cout << "         16 = " << binToHex(intToBinary(16)) << 'h' << endl;




    cout << "Press any key to continue . . .";
    cin.get();

    return 0;
}