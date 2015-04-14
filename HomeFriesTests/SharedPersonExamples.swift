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

// setting this value higher causes an exponential increase in memory usage
let NUM_PROP_TESTS = UInt(1e3)

class SharedHashableExamples: QuickConfiguration {
    override class func configure(configuration: Configuration!) {
        sharedExamples("a hashable person") { (contextProvider: SharedExampleContext) in
            let context = contextProvider()

            let wrappedHashFn = context["hashFn"] as! ObjectWrapper<PersonHashFunction>

            let contextHashFn: PersonHashFunction = wrappedHashFn.value

            let hashPersonWithContextHash = hashPerson(forContext: contextHashFn)

            let isPersonEqualToItselfWithContextHash: (Person) -> Bool = isPersonEqualToItself(contextHashFn)

            let hashSelector = Selector(context["hashSelector"] as! String)

            it("should be equal to itself when properties are 'empty'") {
                let emptyPerson = Person(firstName: "", middleName: "", lastName: "", age: 0)
                expect(isPersonEqualToItselfWithContextHash(emptyPerson)).to(beTrue())
            }

            it("should produce copies that are equal to the original") {
                Assert(forAll(DefaultPersonGenerator()) { (args: AnyObject!) -> Bool in
                    let person = args as! Person
                    return isPersonEqualToItselfWithContextHash(person)
                },
                numberOfTests: NUM_PROP_TESTS)
            }

            it("should have hashes that are equal when objects are equal") {
                let shortString = FOXStringOfLengthRange(1, 2);
                let peopleWithShortNames = FOXTuple([shortString, shortString].map(PersonGeneratorWithNames))
                Assert(forAll(peopleWithShortNames) { (args: AnyObject!) -> Bool in
                    let vals = args as! [Person]
                    let a = vals[0]
                    let b = vals[1]
                    return (a == b) == (hashPersonWithContextHash(a) == hashPersonWithContextHash(b))
                },
                numberOfTests: NUM_PROP_TESTS)
            }

            it("should use the specified selector as its hash algorithm") {
                let personWithDynamicHash = Person(firstName: "",
                                                   middleName: "",
                                                   lastName: "",
                                                   age: 0,
                                                   hashSelector: hashSelector);
                expect(UInt(personWithDynamicHash.hash)).to(equal(hashPersonWithContextHash(personWithDynamicHash)));
            }
        }
    }
}

class AppleHashSpec: QuickSpec {
    override func spec() {
        itBehavesLike("a hashable person") { [
            "hashFn": ObjectWrapper(Person.appleHash),
            "hashSelector": "appleHash"
        ] }
    }
}

class BoostHashSpec: QuickSpec {
    override func spec() {
        itBehavesLike("a hashable person") { [
            "hashFn": ObjectWrapper(Person.boostHash),
            "hashSelector": "boostHash"
        ] }
    }
}

class RotatedXorHashSpec: QuickSpec {
    override func spec() {
        itBehavesLike("a hashable person") { [
            "hashFn": ObjectWrapper(Person.rotatedXorHash),
            "hashSelector": "rotatedXorHash"
        ] }
    }
}

class XorHashSpec: QuickSpec {
    override func spec() {
        itBehavesLike("a hashable person") { [
            "hashFn": ObjectWrapper(Person.xorHash),
            "hashSelector": "xorHash"
        ] }
    }
}

class ShiftedXorHashSpec: QuickSpec {
    override func spec() {
        itBehavesLike("a hashable person") { [
            "hashFn": ObjectWrapper(Person.shiftedXorHash),
            "hashSelector": "shiftedXorHash"
        ] }
    }
}
