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
        var returnedResponse: RestResponse?
        
        var rc = RestCall({ (response: RestResponse) -> Void in
            returnedResponse = response
            self.called = true
        })
        
        var result = rc.configureForGet("https://itunes.apple.com/search?term=Pink+Floyd")
        XCTAssertTrue(result)
        
        loopUntilCalled()
        
        XCTAssertTrue(returnedResponse != nil)
        XCTAssertTrue(returnedResponse!.didSucceed())
        
        switch(returnedResponse!) {
        case let .Success(statusCode, localizedDescription, json):
            XCTAssertEqual(200, statusCode)
            XCTAssertEqual("no error", localizedDescription)
            XCTAssertTrue(json != nil)
        default:
            XCTFail("Bad status code")
        }
        
        let jsonOptional : JSON? = returnedResponse?.getJSON()
        XCTAssertTrue(jsonOptional != nil)
        let json: JSON = jsonOptional!
        
        // Note that JSON converted types are NS* types from
        // the Foundation library
        var nsJsonDict = json as NSDictionary
        var nsResultCount = nsJsonDict["resultCount"] as NSNumber
        XCTAssertTrue(nsResultCount.integerValue == 50)
        
        var nsResults = nsJsonDict["results"] as NSArray
        XCTAssertTrue(nsResults.count == 50)
        
        var nsTrack = nsResults[0] as NSDictionary
        XCTAssertTrue(nsTrack.count == 31)
        
        var nsArtistId = nsTrack["artistId"] as NSNumber
        var nsArtistName = nsTrack["artistName"] as NSString
        var nsTrackPrice = nsTrack["trackPrice"] as NSNumber
        XCTAssertTrue(nsArtistName == "Pink Floyd")
        
        // Note that JSON converted types can be converted to
        // Swift Value types anyway.
        var swJsonDict = json as [String: JSON]
        var swResultCount = swJsonDict["resultCount"] as Int
        XCTAssertTrue(swResultCount == 50)
        
        var swResults = swJsonDict["results"] as [JSON]
        XCTAssertTrue(swResults.count == 50)
        
        var swTrack = swResults[0] as [String: JSON]
        XCTAssertTrue(swTrack.count == 31)
        
        var swArtistId = swTrack["artistId"] as Int
        var swArtistName = swTrack["artistName"] as String
        var swTrackPrice = swTrack["trackPrice"] as Double
        XCTAssertTrue(nsArtistName == "Pink Floyd")
        
        var contents = Content.createFromJSONArray(swResults)
        XCTAssertEqual(50, contents.count)
        for content in contents {
            XCTAssertEqual(content.ArtistName, "Pink Floyd")
        }

    }
}