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
public typealias JSONDictionary = [String:JSON]

public func toStringFromDate(format:String, date: NSDate) -> String {
    var formatter = NSDateFormatter()
    formatter.dateFormat = format
    formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
    return formatter.stringFromDate(date)
}

public func toDateFromString(format: String, dateString: String) -> NSDate? {
    var formatter = NSDateFormatter()
    formatter.dateFormat = format
    return formatter.dateFromString(dateString)
}

extension Dictionary {
    mutating func addIf(key: Key, value: Value?) -> Void {
        if let myvalue = value {
            self[key] = myvalue
        }
    }
    
    mutating func addTuplesIf(tuples: (key: Key, value: Value?)...) -> Void {
        for tuple in tuples {
            self.addIf(tuple.0, value: tuple.1)
        }
    }
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

public func asDictionary(object: JSON) -> JSONDictionary? {
    return object as? JSONDictionary
}

public func asArray(object: JSON) -> JSONArray? {
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

// first parameter is optional, function must exist.
// if first parameter is not null, function is called with it
func nullBind<B>(optional: JSON?, f:(JSON -> B?)) -> B? {
    if let value: JSON = optional {
        return f(value)
    }
    return .None
}

// null bind operator
infix operator >>- { associativity left precedence 150 }
func >>-<B>(a: JSON?, f: JSON -> B?) -> B? {
    return nullBind(a, f)
}


// applicative apply operators
infix operator <*> { associativity left }
infix operator<**> { associativity left }

// Applicative apply operator.  Second parameter cannot be nil,
// will only apply function if both function and parameter are not nil
func <*><A, B>(f: (A -> B)?, a: A?) -> B? {
    if let x = a {
        if let fx = f {
            return fx(x)
        }
    }
    return .None
}

// Applicative apply operator.  Second parameter can be nil (function
// takes a null parameter as input).
func <**><A,B>(f: (A?->B)?, a: A?) -> B? {
    if let fx = f {
        return fx(a)
    }
    return .None
}

