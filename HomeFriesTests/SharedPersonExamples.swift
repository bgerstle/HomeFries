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

class SharedHashableExamples: QuickConfiguration {
    override class func configure(configuration: Configuration!) {
        sharedExamples("a hashable person") { (contextProvider: SharedExampleContext) in
            let context = contextProvider()

            let hashSelector = Selector(context["hashSelector"] as! String)

            describe("hash properties") {
                 it("should not have problems with symmetry") {
                    let p1 = Person(firstName: "foo", middleName: "", lastName: "bar", age: 0, hashSelector: hashSelector)

                    // "mirror" p1 by creating p2 with flipped first & last names
                    let p2 = Person(firstName: p1.lastName,
                                    middleName: p1.middleName,
                                    lastName: p1.firstName,
                                    age: p1.age,
                                    hashSelector: hashSelector)

                    // oops! flipping the first & last names of p1 in p2 results in a collision
                    expect(p1.hash).notTo(equal(p2.hash))
                }           
                it("should have the same hash and object equivalence to another person") {
                    let shortString = FOXStringOfLengthRange(1, 2);
                    let personWithShortName = PersonGeneratorWithHashAndNames(hashSelector, shortString)
                    let pairsOfPeopleWithShortNames = FOXTuple([personWithShortName, personWithShortName])
                    Assert(forAll(pairsOfPeopleWithShortNames) { (args: AnyObject!) -> Bool in
                        let vals = args as! [Person]
                        let a = vals[0]
                        let b = vals[1]
                        return (a == b) == (a.hash == b.hash)
                        },
                        // setting this value higher causes an exponential increase in memory usage
                        numberOfTests: UInt(1e3))
                }
            }

            describe("equality & copying") {
                it("should be equal to itself when properties are 'empty'") {
                    let emptyPerson = Person(firstName: "", middleName: "", lastName: "", age: 0, hashSelector: hashSelector)
                    let copyOfEmptyPerson: Person = emptyPerson.copy() as! Person
                    expect(emptyPerson).to(equal(copyOfEmptyPerson))
                    expect(emptyPerson.hash).to(equal(copyOfEmptyPerson.hash))
                }

                fit("should produce copies that are equal to the original") {
                    Assert(forAll(PersonGeneratorWithHash(hashSelector)) { (args: AnyObject!) -> Bool in
                        let person = args as! Person
                        let copyOfPerson = person.copy() as! Person
                        return person == copyOfPerson && person.hash == copyOfPerson.hash
                        },
                        numberOfTests: 50)
                }
            }

            describe("dynamic hashing") {
                fit("should use the specified selector as its hash algorithm") {
                    let hashFn: PersonHashFunction = (context["hashFn"] as! ObjectWrapper).value
                    let person = Person(firstName: "",
                                        middleName: "",
                                        lastName: "",
                                        age: 0,
                                        hashSelector: hashSelector);
                    expect(UInt(person.hash)).to(equal(hashFn(person)()))
                }
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
