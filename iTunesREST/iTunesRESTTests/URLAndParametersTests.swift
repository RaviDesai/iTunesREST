//
//  URLAndParametersTests.swift
//  iTunesREST
//
//  Created by Ravi Desai on 12/4/14.
//  Copyright (c) 2014 RSD. All rights reserved.
//

import Cocoa
import XCTest
import iTunesREST

class URLAndParametersTests: XCTestCase {
    func testWithNoParameters() {
        var urlAndParams = URLAndParameters(url: "https://itunes.apple.com/")
        XCTAssertEqual(urlAndParams.description, "https://itunes.apple.com/")
        XCTAssertEqual(urlAndParams.description.hashValue, "https://itunes.apple.com/".hashValue)
        
        var secondOne = URLAndParameters(url: "https://itunes.apple.com/")
        XCTAssertEqual(urlAndParams, secondOne);
    }
    
    func testWithOneParameter() {
        var urlAndParams = URLAndParameters(url: "https://itunes.apple.com/", parameters: (name: "term", value: "Floyd"))
        XCTAssertEqual(urlAndParams.description, "https://itunes.apple.com/?term=Floyd")
    }
    
    func testWithTwoParameters() {
        var urlAndParams = URLAndParameters(url: "https://itunes.apple.com/", parameters: (name: "term", value: "Pink"), (name: "nextTerm", value: "Floyd"))
        XCTAssertEqual(urlAndParams.description, "https://itunes.apple.com/?nextTerm=Floyd&term=Pink")
    }
    
    func testWithTwoParametersThatHaveEscapedCharacters() {
        var urlAndParams = URLAndParameters(url: "https://itunes.apple.com/", parameters: (name: "1Term", value: "Rowan&Martin=Funny"), (name: "2Term", value: "Who's afraid of V. Wolfe???"))
        XCTAssertEqual(urlAndParams.description, "https://itunes.apple.com/?1Term=Rowan%26Martin%3DFunny&2Term=Who's%20afraid%20of%20V.%20Wolfe%3F%3F%3F")
    }
}