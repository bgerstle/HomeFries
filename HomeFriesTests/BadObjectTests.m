//
//  BadObjectTests.m
//  HomeFries
//
//  Created by Brian Gerstle on 4/30/15.
//  Copyright (c) 2015 Brian Gerstle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <Quick/Quick.h>
#import <Nimble/Nimble-Swift.h>
#import <Nimble/Nimble.h>

@interface BadObject : NSObject
@property (nonatomic) NSNumber* flag;
@end

@implementation BadObject

@end

QuickSpecBegin(BadObjectTests)

describe(@"NSObject default implementations", ^{
    it(@"should fail equality tests even if data is the same", ^{
        BadObject* a = [BadObject new];
        BadObject* b = [BadObject new];

        // since a & b are two different objects, they are not identical
        expect(a).notTo(beIdenticalTo(b));

        // however, if they have identical properites, they *should* be considered equivalent
        // and obey the hashing & equality expectations for equivalent objects
        a.flag = b.flag = @YES;
        expect(a.flag).to(equal(b.flag));

        // even though the properties are identical, isEqual: fails
        expect(a).notTo(equal(b));

        // hash relies on object identity, so two equivalent objects don't have the same hash
        // with the default implementation
        expect(@(a.hash)).notTo(equal(@(b.hash)));

        // the default isEqual and hash implementations' reliance on *identity* instead of equality
        // make them much less useful in unique collections (e.g. sets & dictionary keys)
        expect([NSSet setWithObject:a]).notTo(contain(b));
    });
});

QuickSpecEnd
