//
//  PersonGenerators.h
//  HomeFries
//
//  Created by Brian Gerstle on 4/12/15.
//  Copyright (c) 2015 Brian Gerstle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Fox/Fox.h>

extern id<FOXGenerator> DefaultPersonStringGenerator();

extern id<FOXGenerator> PersonGeneratorWithHashAndNames(SEL hashSel, id<FOXGenerator> strGen);

extern id<FOXGenerator> PersonGeneratorWithHash(SEL hashSel);

extern id<FOXGenerator> PersonGeneratorWithNames(id<FOXGenerator> strGen);

extern id<FOXGenerator> DefaultPersonGenerator();

extern id<FOXGenerator> ReallyLongStringGenerator(NSInteger size);
