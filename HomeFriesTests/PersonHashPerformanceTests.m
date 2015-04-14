//
//  PersonHashSpecs.m
//  HomeFries
//
//  Created by Brian Gerstle on 4/12/15.
//  Copyright (c) 2015 Brian Gerstle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <Quick/Quick.h>
#import <Fox/Fox.h>
#import "HomeFriesTests-Swift.h"
#import "PersonGenerators.h"
#import "Person.h"

static NSArray* PerformanceSamples() {
    static NSArray* SAMPLES;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SAMPLES = FOXSampleWithCount(PersonGeneratorWithNames(ReallyLongStringGenerator(1e3)), 1e3);
    });
    return SAMPLES;
}

#define PERF_TEST(SEL) \
@interface SEL##PerformanceTests: XCTestCase \
@end \
@implementation SEL##PerformanceTests \
- (void)testPerformance { \
    NSArray* samples = PerformanceSamples(); \
    [self measureBlock:^{ \
        for (Person* p in samples) { \
            [p SEL]; \
        } \
    }]; \
} \
@end

PERF_TEST(appleHash)
PERF_TEST(boostHash)
PERF_TEST(xorHash)
PERF_TEST(shiftedXorHash)
PERF_TEST(rotatedXorHash)
