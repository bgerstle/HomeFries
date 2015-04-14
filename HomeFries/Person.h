#import <Foundation/Foundation.h>

@interface Person : NSObject <NSCopying>
@property (nonatomic, readonly, copy) NSString* firstName;
@property (nonatomic, readonly, copy) NSString* middleName;
@property (nonatomic, readonly, copy) NSString* lastName;
@property (nonatomic, readonly) UInt8 age;

/// @warning For testing only
@property (nonatomic, readwrite) SEL hashSelector;

- (instancetype)initWithFirstName:(NSString*)firstName
                       middleName:(NSString*)middleName
                         lastName:(NSString*)lastName
                              age:(UInt8)age;

- (instancetype)initWithFirstName:(NSString*)firstName
                       middleName:(NSString*)middleName
                         lastName:(NSString*)lastName
                              age:(UInt8)age
                     hashSelector:(SEL)hashSel NS_DESIGNATED_INITIALIZER;

- (NSUInteger)boostHash;

- (NSUInteger)appleHash;

- (NSUInteger)xorHash;

- (NSUInteger)shiftedXorHash;

- (NSUInteger)rotatedXorHash;

@end
