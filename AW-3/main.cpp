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

string intToBinary(int num) {
    string out;

    // positive
    if(num >= 0) {
        int rem;
        do {
            rem = num % 2;
            out += intToString(rem);
            num = num / 2;
        } while(num != 0);
    }
    // negative
    else {
        // @TODO
    }

    // ensure 32 bits
    while(out.size() < 32) {
        out = "0" + out;
    }

    return out;
}

string binToHex(string bin) {
    if(bin.size() % 4 != 0) { return ""; } // ensure multiple of 4

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
    hexMap["1010"] = 'A';
    hexMap["1011"] = 'B';
    hexMap["1100"] = 'C';
    hexMap["1101"] = 'D';
    hexMap["1110"] = 'E';
    hexMap["1111"] = 'F';

    for(int i = 0; i < bin.size(); i+=4) {
        out += hexMap[bin.substr(i, i+4)];
    }

    return out;
}

int main() {

    // cout << intToBinary(5) << endl;
    cout << binToHex("00010100") << endl;

    return 0;
}