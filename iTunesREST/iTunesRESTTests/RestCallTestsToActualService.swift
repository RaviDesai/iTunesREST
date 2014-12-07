//
//  File.swift
//  iTunesREST
//
//  Created by Ravi Desai on 12/2/14.
//  Copyright (c) 2014 RSD. All rights reserved.
//

import Cocoa
import XCTest
import iTunesREST

class RestCallTestsToActualService: XCTestCase {
    var called = false
    let runLoop = NSRunLoop.currentRunLoop();

    func loopUntilCalled() {
        while (!self.called) {
            self.runLoop.runMode(NSDefaultRunLoopMode, beforeDate: NSDate(timeIntervalSinceNow: 0.1));
        }
    }

    func testRestCallToiTunes() {
        var returnedRequest: NSURLRequest?
        var returnedResponse: RestResponse?
        
        var rc = RestCall(startImmediately: false, { (request: NSURLRequest?, response: RestResponse) -> Void in
            returnedRequest = request
            returnedResponse = response
            self.called = true
        })
        XCTAssertFalse(rc.isStarted)
        
        var result = rc.configureForGet(URLAndParameters(url: "https://itunes.apple.com/search", parameters: (name: "term", value: "Pink+Floyd")))
        XCTAssertTrue(result)
        
        result = rc.start()
        XCTAssertTrue(result)

        loopUntilCalled()
        
        XCTAssertTrue(returnedRequest != nil)
        XCTAssertTrue(returnedResponse != nil)
        XCTAssertTrue(returnedResponse!.didSucceed())
        
        switch(returnedResponse!) {
        case let .Success(statusCode, localizedDescription, json):
            XCTAssertEqual(200, statusCode)
            XCTAssertEqual("no error", localizedDescription)
            XCTAssertTrue(json != nil)
            
            var jsonDict = json as? NSDictionary
            XCTAssertTrue(jsonDict != nil)
            
            var resultCount = jsonDict!["resultCount"] as? Int
            XCTAssertTrue(resultCount != nil)
            XCTAssertEqual(50, resultCount!)
            
            var results = jsonDict!["results"] as? JSONArray
            XCTAssertTrue(results != nil)
            XCTAssertEqual(50, results!.count)
        default:
            XCTFail("Bad status code")
        }
    }
}