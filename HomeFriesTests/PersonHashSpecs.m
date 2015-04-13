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

static NSArray* PerformanceSamples() {
    static NSArray* SAMPLES;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        SAMPLES = FOXSampleWithCount(PersonGenerator(ReallyLongStringGenerator()), 1e3);
    });
    return SAMPLES;
}

@interface AppleHashPerformanceTests: XCTestCase
@end

@implementation AppleHashPerformanceTests
- (void)testPerformance {
    // need to ensure the static data evaluated *before* the call to `measureBlock`
    // can haz autoclosure plzzz
    [self measureBlock:^{
        for (Person* p in PerformanceSamples()) {
            [p appleHash];
        }
    }];
}

@end

@interface PersonHashSpecs : QuickSpec

@end

@implementation PersonHashSpecs

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
