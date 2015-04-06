#import <Foundation/Foundation.h>

// extracted apple implementation
// http://opensource.apple.com/source/CF/CF-550/CFUtilities.c
#define ELF_STEP(B) T1 = (H << 4) + B; T2 = T1 & 0xF0000000; if (T2) T1 ^= (T2 >> 24); T1 &= (~T2); H = T1;

static NSUInteger AAPLHashBytes(uint8_t *bytes, CFIndex length) {
    /* The ELF hash algorithm, used in the ELF object file format */
    UInt32 H = 0, T1, T2;
    CFIndex rem = length;
    while (3 < rem) {
	ELF_STEP(bytes[length - rem]);
	ELF_STEP(bytes[length - rem + 1]);
	ELF_STEP(bytes[length - rem + 2]);
	ELF_STEP(bytes[length - rem + 3]);
	rem -= 4;
    }
    switch (rem) {
    case 3:  ELF_STEP(bytes[length - 3]);
    case 2:  ELF_STEP(bytes[length - 2]);
    case 1:  ELF_STEP(bytes[length - 1]);
    case 0:  ;
    }
    return H;
}
#undef ELF_STEP

template <typename T, typename R=NSUInteger>
inline R AAPLHash(T x) {
#if 0
    return [[NSData dataWithBytesNoCopy:&x length:sizeof(T) freeWhenDone:NO] hash];
#else
    return AAPLHashBytes((uint8_t*)&x, sizeof(T));
#endif
}
