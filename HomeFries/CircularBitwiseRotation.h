//
//  CicularBitwiseRotation.h
//  ObjectEquality
//
//  Created by Brian Gerstle on 3/26/15.
//  Copyright (c) 2015 Brian Gerstle. All rights reserved.
//

#import <Foundation/Foundation.h>

// taken from MA's blog:
// https://www.mikeash.com/pyblog/friday-qa-2010-06-18-implementing-equality-and-hashing.html
__attribute__((const, pure)) static
long int circularBitwiseRotation(long int x, long int s) {
    return (x << s) | (x >> (sizeof(x) * CHAR_BIT - s));
}