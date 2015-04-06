#ifndef ObjectEquality_EqualityMacros_h
#define ObjectEquality_EqualityMacros_h

#define NIL_OR_EQUAL(x, sel, y) ((x) == (y) || [(x) sel (y)])

#endif
