//
//  main.swift
//  SampleApp
//
//  Created by Ravi Desai on 12/2/14.
//  Copyright (c) 2014 RSD. All rights reserved.
//

import Foundation
import iTunesREST

var r = RestResponse.Success(200, "OK", nil)

if r.didSucceed() {
    println("Good")
} else {
    println("Bad")
}