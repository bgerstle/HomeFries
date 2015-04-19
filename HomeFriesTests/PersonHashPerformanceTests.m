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
        SAMPLES = FOXSampleWithCount(PersonGeneratorWithNames(FOXAlphabeticalStringOfLengthRange(1, 5)), 1e3);
    });
    return SAMPLES;
}

@interface PersonHashPerformanceTests : XCTestCase
@property NSArray* samples;
@end

@implementation PersonHashPerformanceTests

+ (SEL)hashSelector {
    return nil;
}

- (SEL)hashSelector {
    return [[self class] hashSelector];
}

- (void)setUp {
    [super setUp];
    // samples are only generated once to ensure all performance tests are run on the same data
    // (see dispatch_once above)
    self.samples = PerformanceSamples();

    // each test requires the "people" to have their hash algorithm set
    for (Person* p in self.samples) {
        p.hashSelector = self.hashSelector;
    }
}

+ (NSArray*)testInvocations {
    if (self.hashSelector) {
        return [super testInvocations];
    } else {
        NSLog(@"Skipping performance suite %@", self);
        return nil;
    }
}

- (NSDictionary*)createDictionaryFromSamples {
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:self.samples.count];
    for (Person* p in self.samples) {
        [dict setObject:@"foo" forKey:p];
    }
    return dict;
}

- (NSSet*)createSetFromSamples {
    NSMutableSet* set = [NSMutableSet setWithCapacity:self.samples.count];
    for (Person* p in self.samples) {
        [set addObject:p];
    }
    return set;
}

- (void)testNumberOfCollisions {
    NSUInteger numCollisions = 0;
    for (NSUInteger i = 0; i < self.samples.count - 1; i++) {
        Person* pi = self.samples[i];
        for (NSUInteger j = i+1; j < self.samples.count; j++) {
            Person* pj = self.samples[j];
            if ([pi isEqualToPerson:pj] != (pi.hash == pj.hash)) {
                /*
                 if object equality is not the same as hash equality, we have a collision. i.e. two identical objects
                 have different hashes or two different objects have the same hash
                */
                numCollisions++;
            }
        }
    }
    NSLog(@"Number of collisions using %@: %lu", NSStringFromSelector(self.hashSelector), numCollisions);
}

- (void)testHashPerformance {
    [self measureBlock:^{
        for (Person* p in self.samples) {
            [p hash];
        }
    }];
}

- (void)testSetInsertionPerformance {
    [self measureBlock:^{
        [self createSetFromSamples];
    }];
}

- (void)testSetMembershipPerformance {
    NSSet* set = [self createSetFromSamples];
    [self measureBlock:^{
        for (Person* p in self.samples) {
            [set containsObject:p];
        }
    }];
}

- (void)testDictionaryInsertionPerformance {
    [self measureBlock:^{
        [self createDictionaryFromSamples];
    }];
}

- (void)testDictionaryRetrievalPerformance {
    NSDictionary* dict = [self createDictionaryFromSamples];
    [self measureBlock:^{
        for (Person* p in self.samples) {
           __unused id value = dict[p];
        }
    }];
}

@end


#define PERF_TEST(SELECTOR) \
@interface SELECTOR##PerformanceTests: PersonHashPerformanceTests \
@end \
@implementation SELECTOR##PerformanceTests \
+ (SEL)hashSelector { return @selector(SELECTOR); } \
@end

PERF_TEST(appleHash)
PERF_TEST(boostHash)
PERF_TEST(xorHash)
PERF_TEST(shiftedXorHash)
PERF_TEST(rotatedXorHash)
