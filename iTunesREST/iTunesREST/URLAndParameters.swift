//
//  URLAndParameters.swift
//  iTunesREST
//
//  Created by Ravi Desai on 12/4/14.
//  Copyright (c) 2014 RSD. All rights reserved.
//

import Foundation

private func buildURLQueryPartAllowedCharacterSet() -> NSCharacterSet {
    var URLQueryPartAllowedCharacterSet = NSCharacterSet.URLQueryAllowedCharacterSet().mutableCopy() as NSMutableCharacterSet;
    URLQueryPartAllowedCharacterSet.removeCharactersInString("&=?")
    return URLQueryPartAllowedCharacterSet
}

public var URLQueryPartAllowedCharacterSet: NSCharacterSet = buildURLQueryPartAllowedCharacterSet()


public typealias NameValuePair = (name: String, value: String)

public struct URLAndParameters: Printable, DebugPrintable, Hashable {
    var URL: String
    var Parameters = [NameValuePair]()
    
    public init (url: String, parameters: NameValuePair...) {
        self.URL = url
        for param in parameters {
            var encodedValue = param.value.stringByAddingPercentEncodingWithAllowedCharacters(URLQueryPartAllowedCharacterSet) ?? String()
            self.Parameters.append(NameValuePair(name: param.name, value: encodedValue))
        }
        
        self.Parameters.sort {(first, second) -> Bool in
            return first.name < second.name || (first.name == second.name && first.value < second.value)
        }
    }
    
    public var description: String {
        get {
            if (self.Parameters.count > 0) {
                let paramString = "&".join(self.Parameters.map { "\($0.name)=\($0.value)" })
                return "\(self.URL)?\(paramString)";
            } else {
                return self.URL
            }
        }
    }
    
    public var debugDescription: String {
        get { return self.description }
    }
    
    public var hashValue: Int { get { return self.description.hashValue } }
    
}

public func ==(left: URLAndParameters, right: URLAndParameters) -> Bool {
    return left.description == right.description
}
