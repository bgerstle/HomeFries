#import "Person.h"
#import "CircularBitwiseRotation.h"
#import "BGHashing.hpp"
#import "AAPLHashBytes.hpp"

typedef struct {
    NSUInteger firstName;
    NSUInteger middleName;
    NSUInteger lastName;
    UInt8 age;
} PersonPropertyHashes;

static PersonPropertyHashes PersonPropertyHashesMake(Person* p) {
    PersonPropertyHashes hashes;
    // the memory must be set to 0, otherwise the address space will contain weird data which causes
    // unexpected hash values
    memset(&hashes, 0, sizeof(PersonPropertyHashes));
    hashes.firstName = p.firstName.hash;
    hashes.middleName = p.middleName.hash;
    hashes.lastName = p.lastName.hash;
    hashes.age = p.age;
    return hashes;
}

@interface Person ()
{
    SEL _hashSelector;
}

@end

@implementation Person


- (instancetype)initWithFirstName:(NSString *)firstName
                       middleName:(NSString *)middleName
                         lastName:(NSString *)lastName
                              age:(UInt8)age {
    return [self initWithFirstName:firstName
                        middleName:middleName
                          lastName:lastName
                               age:age
                      hashSelector:@selector(appleHash)];
}

- (instancetype)initWithFirstName:(NSString *)firstName
                       middleName:(NSString *)middleName
                         lastName:(NSString *)lastName
                              age:(UInt8)age
                     hashSelector:(SEL)hashSel {
    NSParameterAssert(hashSel != @selector(hash));
    self = [super init];
    if (self) {
        _firstName = [firstName copy];
        _middleName = [middleName copy];
        _lastName = [lastName copy];
        _age = age;
        _hashSelector = hashSel;
    }
    return self;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"%@ { \n"
            "\t" "firstName: '%@' \n"
            "\t" "middleName: '%@' \n"
            "\t" "lastName: '%@' \n"
            "\t" "age: %d \n"
            "}",
            [super description],
            self.firstName,
            self.middleName,
            self.lastName,
            self.age];
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    } else if ([object isKindOfClass:[Person class]]) {
        return [self isEqualToPerson:object];
    } else {
        return NO;
    }
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return [[[self class] alloc] initWithFirstName:self.firstName
                                        middleName:self.middleName
                                          lastName:self.lastName
                                               age:self.age
                                      hashSelector:self.hashSelector];
}

- (BOOL)isEqualToPerson:(Person*)person {
    return (self.firstName == person.firstName || [self.firstName isEqualToString:person.firstName])
    && (self.middleName == person.middleName || [self.middleName isEqualToString:person.middleName])
    && (self.lastName == person.lastName || [self.lastName isEqualToString:person.lastName])
    && self.age == person.age;
}

- (NSUInteger)hash {
    NSInvocation* hashInvocation = [NSInvocation invocationWithMethodSignature:
                                    [self methodSignatureForSelector:_hashSelector]];
    [hashInvocation setSelector:_hashSelector];
    [hashInvocation invokeWithTarget:self];
    NSUInteger* hash = (NSUInteger*) alloca(hashInvocation.methodSignature.methodReturnLength);
    [hashInvocation getReturnValue:hash];
    return *hash;
}

- (NSUInteger)boostHash {
    return BGHashCombine((NSObject*)self.firstName,
                         (NSObject*)self.middleName,
                         (NSObject*)self.lastName,
                         self.age);
}

- (NSUInteger)appleHash {
    // modification of cocoanetics approach
    // http://www.cocoanetics.com/2013/02/fast-hashing/
    return AAPLHash(PersonPropertyHashesMake(self));
}

- (NSUInteger)xorHash {
    return self.firstName.hash ^ self.middleName.hash ^ self.lastName.hash ^ self.age;
}

- (NSUInteger)shiftedXorHash {
    return self.firstName.hash ^ (self.middleName.hash << 1) ^ (self.lastName.hash << 2) ^ (self.age << 3);
}

- (NSUInteger)rotatedXorHash {
    return self.firstName.hash
    ^ flipBitsWithAdditionalRotation(self.middleName.hash, 1)
    ^ flipBitsWithAdditionalRotation(self.lastName.hash, 2)
    ^ flipBitsWithAdditionalRotation(self.age, 3);
}

@end
