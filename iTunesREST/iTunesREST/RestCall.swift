//
//  RestCall.swift
//  iTunesREST
//
//  Created by Ravi Desai on 12/2/14.
//  Copyright (c) 2014 RSD. All rights reserved.
//

import Foundation

public typealias RestCallbackFunction = (response: RestResponse) -> Void

public class RestCall {
    private var started: Bool
    private let callback : RestCallbackFunction
    private var data = NSMutableData()
    
    private var url: NSURL?
    private var request: NSURLRequest?
    private var conn: NSURLConnection?
    private var response: NSHTTPURLResponse?
    
    public init(callback: RestCallbackFunction) {
        self.callback = callback
        self.started = false
    }
    
    private func connect(toUrl: String, forMethod: String) -> Bool {
        var result = false;
        if let url = NSURL(string: toUrl) {
            self.url = url
            let mutableRequest = NSMutableURLRequest(URL: url)
            mutableRequest.setValue("application/json", forHTTPHeaderField: "Accept")
            mutableRequest.HTTPMethod = forMethod
            
            self.request = mutableRequest as NSURLRequest;
            self.conn = NSURLConnection(request: mutableRequest, delegate: self, startImmediately: true)
            result = self.conn != nil
            self.started = result
        }
        
        if !result {
            self.callback(response: RestResponse.CouldNotConnectToURL(toUrl))
        }
        return result;
    }
    
    public func configureForGet(toUrl: String) -> Bool {
        return connect(toUrl, forMethod: "GET")
    }

    dynamic func connection(connection: NSURLConnection!, didReceiveResponse response: NSURLResponse) {
        self.response = response as? NSHTTPURLResponse
        self.data.length = 0;
    }
    
    dynamic func connection(connection: NSURLConnection!, didReceiveData data: NSData) {
        self.data.appendData(data)
    }
    
    dynamic func connection(connection: NSURLConnection!, didFailWithError error: NSError) {
        self.callback(response: RestResponse.SystemFailure(error))
    }
    
    dynamic func connectionDidFinishLoading(connection: NSURLConnection!) {
        var restResponse: RestResponse = RestResponse.HTTPStatusCodeFailure(0, "no HTTP response received");
        
        if let httpResponse = self.response {
            if (httpResponse.statusCode >= 200 && httpResponse.statusCode < 300) {
                var result:JSON?
                var jsonErrorOptional: NSError?
                if (self.data.length > 0) {
                    result = NSJSONSerialization.JSONObjectWithData(self.data, options: NSJSONReadingOptions(0), error: &jsonErrorOptional)
                }
                
                if let error = jsonErrorOptional {
                    restResponse = RestResponse.JSONSerializationFailure(error)
                } else {
                    let localizedString = NSHTTPURLResponse.localizedStringForStatusCode(httpResponse.statusCode)
                    restResponse = RestResponse.Success(httpResponse.statusCode, localizedString, result)
                }
            } else {
                let localizedString = NSHTTPURLResponse.localizedStringForStatusCode(httpResponse.statusCode)
                restResponse = RestResponse.HTTPStatusCodeFailure(httpResponse.statusCode, localizedString)
            }
        }
        
        self.callback(response: restResponse)
    }

    
}