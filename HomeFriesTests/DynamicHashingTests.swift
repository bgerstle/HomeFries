//
//  DynamicHashingTests.swift
//  HomeFries
//
//  Created by Brian Gerstle on 4/11/15.
//  Copyright (c) 2015 Brian Gerstle. All rights reserved.
//

import Foundation
import XCTest
import Nimble
import HomeFries

class DynamicHashingTests: XCTestCase {
    func testHash() {
        for sel in ["appleHash", "boostHash", "xorHash", "rotatedXorHash", "shiftedXorHash"].map({ Selector($0) }) {
            expect(
            Person(
                firstName: "",
                middleName: "",
                lastName: "",
                age: 0,
                hashSelector: sel).hashValue)
            .notTo(raiseException())
        }
    }
}