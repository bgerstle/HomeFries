//
//  PersonGenerators.c
//  HomeFries
//
//  Created by Brian Gerstle on 4/12/15.
//  Copyright (c) 2015 Brian Gerstle. All rights reserved.
//

#import "PersonGenerators.h"
#import "Person.h"

id<FOXGenerator> DefaultPersonStringGenerator() {
    return FOXAlphabeticalStringOfLengthRange(0, 10);
}

id<FOXGenerator> PersonGeneratorWithHashAndNames(SEL hashSel, id<FOXGenerator> strGen) {
    return FOXMap(FOXTuple(@[strGen, strGen, strGen, FOXPositiveInteger()]), ^Person*(NSArray* args) {
        NSUInteger const age = [args[3] intValue] % UINT8_MAX;
        return [[Person alloc] initWithFirstName:args[0]
                                      middleName:args[1]
                                        lastName:args[2]
                                             age:age
                                    hashSelector:hashSel];
    });
}

id<FOXGenerator> PersonGeneratorWithHash(SEL hashSel) {
    return PersonGeneratorWithHashAndNames(hashSel, DefaultPersonStringGenerator());
}

id<FOXGenerator> PersonGeneratorWithNames(id<FOXGenerator> strGen) {
    return PersonGeneratorWithHashAndNames(@selector(appleHash), strGen);
}

id<FOXGenerator> DefaultPersonGenerator() {
    return PersonGeneratorWithNames(DefaultPersonStringGenerator());
}

// !!!: don't make this too big or you might kill your computer!
id<FOXGenerator> ReallyLongStringGenerator(NSInteger size) {
    return FOXBind(FOXArrayOfSize(FOXAlphanumericStringOfLength(1), size),
                   ^id(id characters) {
        return [characters componentsJoinedByString:@""];
    });
}