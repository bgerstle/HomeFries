//
//  flipBitsWithAdditionalRotationTests.m
//  HomeFries
//
//  Created by Brian Gerstle on 4/14/15.
//  Copyright (c) 2015 Brian Gerstle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <Fox/Fox.h>
#import "CircularBitwiseRotation.h"


QuickSpecBegin(CircularBitwiseRotationTests)

describe(@"circular bitwise rotation", ^ {
    it(@"should be the same modulo the size of the input", ^ {
        Assert(forAll(FOXTuple(@[FOXInteger(), FOXChoose(@0, @(NSUINT_BIT))]),
                      ^BOOL(NSArray* args) {
                          long int testValue = [args[0] longValue];
                          NSUInteger rotation = [args[1] unsignedIntegerValue];
                          return flipBitsWithAdditionalRotation(testValue, rotation)
                                 == flipBitsWithAdditionalRotation(testValue, rotation + NSUINT_BIT);
                      }));
    });
    it(@"should equal a corresponding power of two for an input of one", ^{
        Assert(forAll(FOXChoose(@0, @(NSUINT_BIT)),
                      ^BOOL(NSNumber* rotationValue) {
                          NSUInteger rotation = [rotationValue unsignedIntegerValue];
                          return flipBitsWithAdditionalRotation(1, rotation)
                                 == powl(2, (rotation + NSUINT_BIT_2) % NSUINT_BIT);
                      }));
    });
});

QuickSpecEnd
