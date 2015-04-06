//
//  HomeFriesTests.swift
//  HomeFriesTests
//
//  Created by Brian Gerstle on 4/5/15.
//  Copyright (c) 2015 Brian Gerstle. All rights reserved.
//

import UIKit
import XCTest
import Fox
import Nimble
import Quick
import HomeFries

func isPersonEqualToItself(hashFunction: PersonHashFunction)(_ p: Person) -> Bool {
    return p.isEqualToItself(using: hashFunction)
}

func hashPerson(forContext hashFunction: PersonHashFunction)(_ p: Person) -> UInt {
    return hashFunction(p)()
}

let PERFORMANCE_SAMPLES = FOXSampleWithCount(PersonGenerator(ReallyLongStringGenerator()),
                                             UInt(1e3)) as! [Person]

class SharedHashableExamples: QuickConfiguration {
    // setting this value higher causes an exponential increase in memory usage
    static let NUM_PROP_TESTS = UInt(1e3)

//    override class func initialize() {
//        super.initialize()
//        // force evaluation to prevent slowing performance tests
//        SharedHashableExamples.PERFORMANCE_SAMPLES
//    }

    override class func configure(configuration: Configuration!) {
        sharedExamples("a hashable person") { (contextProvider: SharedExampleContext) in
            let context = contextProvider()

            let contextHashFn: PersonHashFunction = (context["hashFn"] as! WrappedPersonHashFunction).hashFn

            let hashPersonWithContextHash = hashPerson(forContext: contextHashFn)

            let isPersonEqualToItselfWithContextHash: (Person) -> Bool = isPersonEqualToItself(contextHashFn)

            it("should be equal to itself when properties are 'empty'") {
                let emptyPerson = Person(firstName: "", middleName: "", lastName: "", age: 0)
                expect(isPersonEqualToItselfWithContextHash(emptyPerson)).to(beTrue())
            }

            it("should produce copies that are equal to the original") {
                Assert(forAll(PersonGenerator()) { (args: AnyObject!) -> Bool in
                    let person = args as! Person
                    return isPersonEqualToItselfWithContextHash(person)
                },
                numberOfTests: SharedHashableExamples.NUM_PROP_TESTS)
            }

            it("should have hashes that are equal when objects are equal") {
                let shortString = FOXStringOfLengthRange(1, 2);
                let peopleWithShortNames = FOXTuple([shortString, shortString].map(PersonGenerator))
                Assert(forAll(peopleWithShortNames) { (args: AnyObject!) -> Bool in
                    let vals = args as! [Person]
                    let a = vals[0]
                    let b = vals[1]
                    return (a == b) == (hashPersonWithContextHash(a) == hashPersonWithContextHash(b))
                },
                numberOfTests: SharedHashableExamples.NUM_PROP_TESTS)
            }
        }
    }
}

// Because we can't sneak functions into dictionaries...
class WrappedPersonHashFunction: NSObject {
    let hashFn: PersonHashFunction
    init(_ hashFn: PersonHashFunction) {
        self.hashFn = hashFn
    }
}

func sharedExampleContext(withHashFn hashFn: PersonHashFunction) -> NSDictionary {
    var context = NSMutableDictionary()
    context.setObject(WrappedPersonHashFunction(hashFn), forKey: "hashFn")
    return context.copy() as! NSDictionary
}

class AppleHashSpec: QuickSpec {
    override func spec() {
        itBehavesLike("a hashable person") { sharedExampleContext(withHashFn: Person.appleHash) }
    }
}

class AppleHashPerformanceTests: XCTestCase {
    func testPerformance() {
        // need to ensure the static data evaluated *before* the call to `measureBlock`
        let samples = PERFORMANCE_SAMPLES
        // can haz autoclosure plzzz
        self.measureBlock { samples.map { Person.appleHash($0)() } }
    }
}

//class BoostHashSpec: QuickSpec {
//    override func spec() {
//        itBehavesLike("a hashable person") { sharedExampleContext(withHashFn: Person.boostHash, self) }
//    }
//}
//
//class RotatedXorHashSpec: QuickSpec {
//    override func spec() {
//        itBehavesLike("a hashable person") { sharedExampleContext(withHashFn: Person.rotatedXorHash, self) }
//    }
//}
//
//class XorHashSpec: QuickSpec {
//    override func spec() {
//        itBehavesLike("a hashable person") { sharedExampleContext(withHashFn: Person.xorHash, self) }
//    }
//}
//
//class ShiftedXorHashSpec: QuickSpec {
//    override func spec() {
//        itBehavesLike("a hashable person") { sharedExampleContext(withHashFn: Person.shiftedXorHash, self) }
//    }
//}
