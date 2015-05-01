//
//  ObjectWrapper.swift
//  HomeFries
//
//  Created by Brian Gerstle on 4/12/15.
//  Copyright (c) 2015 Brian Gerstle. All rights reserved.
//

import Foundation

// Wrapper for sticking non-objects in NSDictionary instances
public class ObjectWrapper<T> {
    public let value: T
    public init(_ value: T) {
        self.value = value
    }
}
