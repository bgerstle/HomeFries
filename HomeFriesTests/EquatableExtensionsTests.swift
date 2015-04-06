//
//  EquatableExtensionsTests.swift
//  HomeFries
//
//  Created by Brian Gerstle on 4/12/15.
//  Copyright (c) 2015 Brian Gerstle. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Fox
import HomeFries

let maybePrintableObject = FOXOptional(FOXAnyPrintableObject());

class EquatableExtensionsTests: QuickSpec {
    override func spec() {
        describe("currayble eq") {
            it("should behave identically to '==' when called with the same arguments") {
                Assert(FOXForAll(FOXTuple([maybePrintableObject, maybePrintableObject])) {
                    (generatedObjs: AnyObject!) -> Bool in
                    let objects = generatedObjs as! NSArray
                    let o1 = objects[0] as! NSObject
                    let o2 = objects[1] as! NSObject
                    let equalToFirst = ==(o1)

                    // doesn't seem to be a way to omit "rhs:"
                    return equalToFirst(rhs: o2) == (o1 == o2)
                })
            }
        }
    }
}