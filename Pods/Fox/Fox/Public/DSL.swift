import Foundation
import XCTest

public func Assert(
    property: FOXGenerator,
    seed: UInt? = nil,
    numberOfTests: UInt? = nil,
    maximumSize: UInt? = nil,
    file: String = __FILE__,
    line: UInt32 = __LINE__) {
    _FOXAssert(property, "", file, line, FOXOptions(
        seed: seed ?? 0, numberOfTests: numberOfTests ?? 0, maximumSize: maximumSize ?? 0
    ));
}

/// Assert `property` with `numberOfTests` (using default values for `seed` and other parameters).
public func Assert(
    property: FOXGenerator,
    numberOfTests: UInt?,
    seed: UInt? = nil,
    maximumSize: UInt? = nil,
    file: String = __FILE__,
    line: UInt32 = __LINE__) {
    _FOXAssert(property, "", file, line, FOXOptions(
        seed: seed ?? 0, numberOfTests: numberOfTests ?? 0, maximumSize: maximumSize ?? 0
    ));
}

/// Assert `property` with `seed` (using default values for `numberOfTests` and other parameters).
public func Assert(
    property: FOXGenerator,
    seed: UInt?,
    numberOfTests: UInt? = nil,
    maximumSize: UInt? = nil,
    file: String = __FILE__,
    line: UInt32 = __LINE__) {
    _FOXAssert(property, "", file, line, FOXOptions(
        seed: seed ?? 0, numberOfTests: numberOfTests ?? 0, maximumSize: maximumSize ?? 0
    ));
}
