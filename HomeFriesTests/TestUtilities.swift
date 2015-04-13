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

public typealias PersonHashFunction = (Person) -> () -> UInt

extension Person {
    func isEqualToItself(using f: PersonHashFunction) -> Bool {
        let itself = self.copy() as! Person
        return self == itself && f(self)() == f(itself)()
    }
}
