// Arman Ashrafian
// CS 3B
// AW - 3
// 1-25-2018

// Convert signed integer to hex

#include <iostream>
#include <string>
#include <sstream>
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
    // @TODO
}

int main() {

    cout << intToBinary(5) << endl;

    return 0;
}