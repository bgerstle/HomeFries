//
//  HashBasedCollectionTest.swift
//  HomeFries
//
//  Created by Brian Gerstle on 4/11/15.
//  Copyright (c) 2015 Brian Gerstle. All rights reserved.
//

import UIKit
import XCTest
import HomeFries
import Fox
import Quick

// might need this to put them in Dictionary objects..?
//extension Person: Hashable, Equatable {
//
//}
//
//public func ==(lhs: Person, rhs: Person) -> Bool {
//    return lhs == rhs
//}

class HashBasedCollectionTest: QuickConfiguration {
    override class func configure(configuration: Configuration ) {
        sharedExamples("a hash-based collection member") { (contextProvider: SharedExampleContext) in
            let context = contextProvider()
            let hashSelectorString = context["selector"] as! String
            let hashSelector = Selector(hashSelectorString)
            describe("hash-based collection membership properties") {
                it("should be usable in a set") {
                    Assert(forAll(FOXArray(PersonGeneratorWithHashAndNames(hashSelector, FOXAlphabeticalStringOfLength(2)))) { (generatedObjects: AnyObject!) -> Bool in
                        let people = generatedObjects as! [Person]
                        let uniquePeople = people.reduce([], combine: { (acc, p) -> [Person] in
                            return contains(acc, p) ? acc : acc + [people.filter(==p).first!]
                        })
                        let collection = Set(people)
                        let result = !isDisjoint(collection, uniquePeople)
                        return result
                    }, numberOfTests: 250)
                }
                pending("should be usable in a dictionary") {

                }
            }
        }
    }

//    func testDictionaryMembership() {
//        Assert(
//        FOXForAll(
//        FOXArray(
//            PersonGenerator(withHash: hashSelector,
//                            FOXAlphabeticalStringOfLength(2)))) { (generatedObjects: AnyObject!) -> Bool in
//            let people = generatedObjects as! [Person]
//            let uniquePeople = people.reduce([], combine: { (acc, p) -> [Person] in
//                return contains(acc, p) ? acc : acc + [people.filter(==p).first!]
//            })
//
//            let collection = people.reduce([:]) { (d: [Person:String], p: Person) -> [Person:String] in
//                var d2 = Dictionary(p, "foo")
//
//                return d2
//            }
//            let result = !isDisjoint(collection, uniquePeople)
//            return result
//        })
//    }
}

class AppleHashBasedCollectionSpec: QuickSpec {
    override func spec() {
        itBehavesLike("a hash-based collection member") { ["selector": "appleHash"] }
    }
}

class XorHashBasedCollectionTests: QuickSpec {
    override func spec() {
        itBehavesLike("a hash-based collection member") { ["selector": "xorHash" ] }
    }
}

class RotatedHashBasedCollectionTests: QuickSpec {
    override func spec() {
        itBehavesLike("a hash-based collection member") { ["selector": "rotatedXorHash"] }
    }
}

class ShiftedXorHashBasedCollectionTests: QuickSpec {
    override func spec() {
        itBehavesLike("a hash-based collection member") { ["selector": "shiftedXorHash"] }
    }
}

class BoostHashBasedCollectionTests: QuickSpec {
    override func spec() {
        itBehavesLike("a hash-based collection member") { ["selector": "boostHash"] }
    }
}
