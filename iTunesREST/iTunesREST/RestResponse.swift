//
//  RestResponse.swift
//  iTunesREST
//
//  Created by Ravi Desai on 12/2/14.
//  Copyright (c) 2014 RSD. All rights reserved.
//
import Foundation

public enum RestResponse : Printable {
    case Success(Int, String, JSON?)
    case JSONSerializationFailure(NSError)
    case HTTPStatusCodeFailure(Int, String)
    case CouldNotConnectToURL(String)
    case SystemFailure(NSError)
    
    public var description: String {
        get {
            switch(self) {
            case let .Success(statusCode, localizedMessage, json):
                return "Success(\(statusCode)): \(localizedMessage)"
            case let .JSONSerializationFailure(error):
                return "Failure in JSON serialization: \(error.localizedDescription)"
            case let .HTTPStatusCodeFailure(statusCode, localizedMessage):
                return "HTTP status code \(statusCode) indicated failure: \(localizedMessage)"
            case let .CouldNotConnectToURL(urlString):
                return "Could not connect to URL: \(urlString)"
            case let .SystemFailure(error):
                return "General system failure: \(error.localizedDescription)"
            }
        }
    }
    
    public func didSucceed() -> Bool {
        switch(self) {
        case let .Success(_, _, _):
            return true
        default:
            return false
        }
    }
    
    public func didFail() -> Bool {
        return !didSucceed()
    }
    
    public func getJSON() -> JSON? {
        switch(self) {
        case let .Success(statusCode, localizedMessage, json):
            return json
        default:
            return nil
        }
    }

}