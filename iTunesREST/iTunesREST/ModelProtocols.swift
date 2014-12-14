//
//  ModelProtocols.swift
//  iTunesREST
//
//  Created by Ravi Desai on 12/2/14.
//  Copyright (c) 2014 RSD. All rights reserved.
//

import Foundation

public protocol SerializableToJSON {
    func convertToJSON() -> JSONDictionary
}

public protocol SerializableFromJSON {
    typealias ConcreteType
    class func createFromJSON(json: JSONDictionary) -> ConcreteType?
}

public protocol SerializableToJSONArray : SerializableToJSON {
    typealias ConcreteType
    class func convertToJSONArray(elements: [ConcreteType]) -> JSONArray
}

public protocol SerializableFromJSONArray : SerializableFromJSON {
    class func createFromJSONArray(elements: JSONArray) -> [ConcreteType]
}

public protocol JSONSerializable : SerializableToJSON, SerializableFromJSON { }

public protocol JSONArraySerializable: JSONSerializable, SerializableToJSONArray, SerializableFromJSONArray {}