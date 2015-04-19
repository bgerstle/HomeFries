//
//  CicularBitwiseRotation.h
//  ObjectEquality
//
//  Created by Brian Gerstle on 3/26/15.
//  Copyright (c) 2015 Brian Gerstle. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSUInteger const NSUINT_BIT = sizeof(NSUInteger) * CHAR_BIT;
static NSUInteger const NSUINT_BIT_2 = NSUINT_BIT / 2;

// taken from MA's blog:
// https://www.mikeash.com/pyblog/friday-qa-2010-06-18-implementing-equality-and-hashing.html
__attribute__((const, pure)) static inline
NSUInteger flipBitsWithAdditionalRotation(NSUInteger x, NSUInteger rotation) {
    // take the amount and adjust it by half the size of x, so an s of 0 results in a "flip" of the bits
    rotation += NSUINT_BIT_2;
    return (x << rotation) | (x >> (NSUINT_BIT - rotation));
}