//
//  RestResponseTests.swift
//  iTunesREST
//
//  Created by Ravi Desai on 12/2/14.
//  Copyright (c) 2014 RSD. All rights reserved.
//

import Cocoa
import XCTest
import iTunesREST

class RestResponseTests: XCTestCase {
    
    func testSystemFailure() {
        var err = NSError(domain: "Domain", code: 99, userInfo: [NSLocalizedDescriptionKey: "My Error"])
        var response = RestResponse.SystemFailure(err)
        XCTAssertEqual("\(response)", "General system failure: My Error")
    }
    
    func testCouldNotConnectFailure() {
        var response = RestResponse.CouldNotConnectToURL("garbage~url")
        XCTAssertEqual("\(response)", "Could not connect to URL: garbage~url")
    }
    
    func testHTTPStatusCodeFailure() {
        var response = RestResponse.HTTPStatusCodeFailure(401, "Unauthorized")
        XCTAssertEqual("\(response)", "HTTP status code 401 indicated failure: Unauthorized")
    }
    
    func testJSONSerializationFailure() {
        var err = NSError(domain: "Domain", code: 99, userInfo: [NSLocalizedDescriptionKey: "Bad JSON"])
        var response = RestResponse.JSONSerializationFailure(err)
        XCTAssertEqual("\(response)", "Failure in JSON serialization: Bad JSON")
    }
    
    func testSuccess() {
        var response = RestResponse.Success(200, "OK", nil)
        XCTAssertEqual("\(response)", "Success(200): OK")
    }
    
}
