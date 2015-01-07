//
//  JSONHelpers.swift
//  iTunesREST
//
//  Created by Ravi Desai on 12/2/14.
//  Copyright (c) 2014 RSD. All rights reserved.
//

import Foundation

public typealias JSON = AnyObject
public typealias JSONArray = [JSON]
public typealias JSONDictionary = [String: JSON]

public func toDateFromString(format: String, dateString: String) -> NSDate? {
    var formatter = NSDateFormatter()
    formatter.dateFormat = format
    return formatter.dateFromString(dateString)
}

func asString(object: JSON) -> String? {
    return object as? String
}

func asDouble(object: JSON) -> Double? {
    return object as? Double
}

func asInt(object: JSON) -> Int? {
    return object as? Int
}

func asDictionary(object: JSON) -> JSONDictionary? {
    return object as? JSONDictionary
}

func asArray(object: JSON) -> JSONArray? {
    return object as? JSONArray
}

func asUrl(object: JSON) -> NSURL? {
    if let urlString = object as? String {
        return NSURL(string: urlString)
    }
    return nil
}

func asDate(format: String)(object: JSON) -> NSDate? {
    if let dateString = object as? String {
        return toDateFromString(format, dateString)
    }
    return nil
}

func nullBind<T>(optional: JSON?, asFunction: JSON -> T?) -> T? {
    if let value: JSON = optional {
        return asFunction(value)
    }
    return nil
}

// null bind operator
infix operator >>- { associativity left precedence 150 }
func >>-<T>(optional: JSON?, asFunction: JSON -> T?) -> T? {
    if let value: JSON = optional {
        return asFunction(value)
    }
    return nil
}

// applicative apply operators
infix operator <*> { associativity left }
infix operator<**> { associativity left }

// Applicative apply operator.  Second parameter cannot be nil,
// will only apply function if both function and parameter are not nil
func <*><A, B>(curryFunc: (A -> B)?, curryParam: A?) -> B? {
    if let curryFunction = curryFunc {
        if let curryParameter = curryParam {
            return curryFunction(curryParameter)
        }
    }
    return nil
}

// Applicative apply operator.  Second parameter can be nil (function
// takes a null parameter as input).
func <**><A,B>(curryFunc: (A?->B)?, curryParam: A?) -> B? {
    if let curryFunction = curryFunc {
        return curryFunction(curryParam)
    }
    return nil
}
