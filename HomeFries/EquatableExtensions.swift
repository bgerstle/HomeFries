//
//  EquatableExtensions.swift
//  HomeFries
//
//  Created by Brian Gerstle on 4/12/15.
//  Copyright (c) 2015 Brian Gerstle. All rights reserved.
//

import Foundation

// Curryable `==`
prefix operator == { }
public prefix func ==<T: Equatable>(lhs: T)(rhs: T) -> Bool {
    return lhs == rhs
}

// For fun, curryable `!=`
prefix operator != { }
public prefix func !=<T: Equatable>(lhs: T)(rhs: T) -> Bool {
    return lhs != rhs
}

public func isEmpty<T: SequenceType>(s: T) -> Bool {
    var gen = s.generate()
    return gen.next() != nil
}

public func isDisjoint<T, S1: SequenceType, S2: SequenceType
                       where T == S1.Generator.Element, T == S2.Generator.Element, T: Equatable>
                       (a1: S1, a2: S2) -> Bool {
    // would be nice to exit early from reduce
    return reduce(a1, false) { (acc, a: T) -> Bool in acc || !contains(a2, a) }
           || reduce(a2, false) { (acc, a: T) -> Bool in acc || !contains(a1, a) }
}
