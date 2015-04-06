//
//  TestUtilities.swift
//  HomeFries
//
//  Created by Brian Gerstle on 4/11/15.
//  Copyright (c) 2015 Brian Gerstle. All rights reserved.
//

import Foundation
import Fox
import HomeFries

typealias PersonHashFunction = (Person) -> () -> UInt

let DefaultPersonStringGenerator = FOXAlphabeticalStringOfLengthRange(0, 10)

func PersonGenerator(withHash hashSel: Selector,
                     _ strGen: FOXGenerator = DefaultPersonStringGenerator) -> FOXGenerator {
    return FOXMap(FOXTuple([strGen, strGen, strGen, FOXPositiveInteger()]), { (args: AnyObject!) -> AnyObject! in
        let vals = args as! [AnyObject]
        let firstName = vals[0] as! String
        let middleName = vals[1] as! String
        let lastName = vals[2] as! String
        let ageValue = vals[3] as! NSNumber
        let age = UInt8(ageValue.intValue % UINT8_MAX)
        return Person(firstName: firstName,
            middleName: middleName,
            lastName: lastName,
            age: age,
            hashSelector: hashSel)
    })
}

func PersonGenerator(_ strGen: FOXGenerator = DefaultPersonStringGenerator) -> FOXGenerator {
    return PersonGenerator(withHash: Selector("appleHash"), strGen)
}

// !!!: don't make this too big or you might kill your computer!
func ReallyLongStringGenerator(size: Int = Int(1e3)) -> FOXGenerator {
    return FOXBind(FOXCharacter(), { (generatedValue: AnyObject!) -> FOXGenerator! in
        let str = (generatedValue as! NSNumber).stringValue
        return FOXReturn(Array(count: size, repeatedValue: str).reduce("", combine: +))
    })
}

extension Person {
    func isEqualToItself(using f: PersonHashFunction) -> Bool {
        let itself = self.copy() as! Person
        return self == itself && f(self)() == f(itself)()
    }
}
