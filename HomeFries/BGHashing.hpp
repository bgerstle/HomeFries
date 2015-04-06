#import <Foundation/Foundation.h>

#import <functional>

// implement std::hash for NSObjects
// this allows BGHashCombine to work for any
namespace std {
    template <> struct hash<NSObject*> {
        size_t operator()(const NSObject* obj) const {
            return [obj hash];
        }
    };
}


// binary pattern, combine hashes using boost approach
// http://www.boost.org/doc/libs/1_37_0/doc/html/hash/reference.html#boost.hash_combine
template <typename ValType=NSUInteger, class A, class B>
ValType BGHashCombine(A seed, B next) {
    ValType seedHash = std::hash<A>()(seed);
    return seedHash ^ (std::hash<B>()(next) + 0x9e3779b9 + (seedHash << 6) + (seedHash >> 2));
}

// unary pattern, return hash
template <typename ValType=NSUInteger, class A>
ValType BGHashCombine(A seed) {
    return std::hash<A>()(seed);
}

// nullary pattern, 0
static inline NSUInteger BGHashCombine() {
    return 0;
}

template <typename ValType=NSUInteger, class A, class B, class ... Types>
inline ValType BGHashCombine(A first, B next, Types ... rest) {
    // recursively combine....
    return BGHashCombine(
            // combination of first's hash w/ next's
            BGHashCombine(first, next),
            // ... and the rest of the args
            BGHashCombine(rest...));
}
