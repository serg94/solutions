/**
 Problem: present number with -2 radix
 Solution Steps: 1. find highest degree in presentation
                2. loop from highest degree to 0 degree, if adding pow(-2, degree) goes to be close to our number add "1", "0" otherwise
                3. vualya 😊
 
 Algorithm notes:
   -2^6    -2^5   -2^4    -2^3   -2^2     -2^1   -2^0
    64     -32     16      -8      4       -2      1
 
 i.g.   0   ->   0
        1   ->   1
        2   ->   110
        3   ->   111
      -11   ->  -110101
 
 Range:         Need_Highest_Degree:
 [0         1]  0  -  2^0   //  this is range of possible different numbers
 [-2        1]  1  -  2^1   //  with -2 radix with mentioned degree
 [-2        5]  2  -  2^2   //  range left number is sum of all negative values  ( -2 + -8 + -32 + .. )
 [-10       5]  3  -  2^3   //  range right number is sum of all positive values ( 1 + 4 + 16 + .. )
 [-10      21]  4  -  2^4
 [-42      21]  5  -  2^5
 [-42      85]  6  -  2^6
 [-170     85]  7  -  2^7
 [-170    341]  8  -  2^8
 .............  .  -  ...
 
 From ranges we can see the progress of numbers.
 i.e. we need high degree for number 67
 lets find highest degree
 from this numbers we can see how positive number depends from degree:
 x + (x - 1)/2 = 2^(2k+1). x is max(1, 5, 21, ...) in range, 
 so we need to find last k where 67 + (67 - 1)/2 <= 2^(2k+1). 
 And take 2k as high, as it's 0 based
 
 for negative number equality is:
 y + y/2 -1 = 2^2k:     -1 is just '0' case, y is absolute value of number
 after finding k take 2*k - 1: also 0 based indises
 */

import Foundation

infix operator ^^ { associativity left precedence 160 }
func ^^ (radix: Double, power: Double) -> Double {
    return pow(radix, power)
}

let number: Double = -11

var number_range: Double
if number < 0 {
    number_range = number + number / 2 - 1
} else {
    number_range = number + (number - 1) / 2
}
number_range = abs(number_range)

var high_degree: Double = 0

if number >= 0 {
    while 2 ^^ (2 * high_degree + 1) < number_range {
        high_degree += 1
    }
    
    high_degree = 2 * high_degree
} else {
    while 2 ^^ (2 * high_degree) < number_range {
        high_degree += 1
    }
    
    high_degree = 2 * high_degree - 1
}

var chars = [Character]()
var tmp_number = -2 ^^ high_degree
if number < 0 {
    chars.append("-")
}
if number == 0 {
    chars.append("0")
} else {
    chars.append("1")
}
high_degree -= 1

while high_degree >= 0 {
    if abs(tmp_number + -2 ^^ high_degree - number) <= abs(tmp_number - number) {
        tmp_number = tmp_number + -2 ^^ high_degree
        chars.append("1")
    } else {
        chars.append("0")
    }
    
    high_degree -= 1
}

let result = String(chars)
