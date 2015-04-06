//
//  BGHashingTests.m
//  ObjectEquality
//
//  Created by Brian Gerstle on 4/5/15.
//  Copyright (c) 2015 Brian Gerstle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
extern "C" {
#import <Fox/Fox.h>
#import <Nimble/Nimble.h>
#import <Nimble/Nimble-Swift.h>
#import <Quick/Quick.h>
#import <Quick/Quick-Swift.h>
}
#import "BGHashing.hpp"

QuickSpecBegin(BGHashingTests)

describe(@"BGHashCombine", ^{
    it(@"should return 0 in nullary form", ^ {
        expect(@(BGHashCombine())).to(equal(@0));
    });

    it(@"should return hash of a given object in unary form", ^ {
        FOXAssert(FOXForAll(FOXAnyPrintableObject(), ^BOOL(NSObject* generatedValue) {
            return BGHashCombine(generatedValue) == [generatedValue hash];
        }));
    });

    it(@"should return hash of a given primitive in unary form" , ^ {
        FOXAssert(FOXForAll(FOXInteger(), ^BOOL(NSNumber* generatedValue) {
            NSUInteger const expectedHash = std::hash<NSInteger>()(generatedValue.integerValue);
            return BGHashCombine(generatedValue.integerValue) == expectedHash;
        }));
    });

    it(@"should recursively combine hashes in variadic form", ^ {
        FOXAssert(FOXForAll(FOXTuple(@[FOXAnyPrintableObject(), FOXAnyPrintableObject(), FOXAnyPrintableObject()]),
                            ^BOOL(NSArray* objects) {
            NSUInteger const unaryResult = BGHashCombine((NSObject*)objects[0]);
            NSUInteger const binaryResult = BGHashCombine((NSObject*)objects[0], (NSObject*)objects[1]);
            NSUInteger const naryResult = BGHashCombine((NSObject*)objects[0],
                                                        (NSObject*)objects[1],
                                                        (NSObject*)objects[2]);
            return naryResult == BGHashCombine(binaryResult, BGHashCombine((NSObject*)objects[2]))
                   && binaryResult != naryResult
                   && unaryResult != binaryResult;
        }));
    });
});

QuickSpecEnd