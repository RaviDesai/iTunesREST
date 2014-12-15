//
//  RestCall.swift
//  iTunesREST
//
//  Created by Ravi Desai on 12/2/14.
//  Copyright (c) 2014 RSD. All rights reserved.
//

import Foundation

public typealias RestCallbackFunction = (request: NSURLRequest?, response: RestResponse) -> Void

@objc public class RestCall {
    private var started: Bool
    private var startImmediately: Bool
    private let callback : RestCallbackFunction
    private var data = NSMutableData()
    
    private var url: NSURL?
    private var request: NSURLRequest?
    private var response: NSHTTPURLResponse?
    private var conn: NSURLConnection?
    
    public init(startImmediately: Bool, callback: RestCallbackFunction) {
        self.callback = callback
        self.startImmediately = startImmediately
        self.started = false
    }
    
    public convenience init(callback: RestCallbackFunction) {
        self.init(startImmediately: true, callback: callback)
    }
    
    private func connect(toUrl : URLAndParameters, forMethod: String, withBody: SerializableToJSON?) -> Bool {
        var success: Bool = false
        if let url = NSURL(string: toUrl.description) {
            self.url = url
            let mutableRequest = NSMutableURLRequest(URL: url)
            mutableRequest.setValue("application/json", forHTTPHeaderField: "Accept")
            mutableRequest.HTTPMethod = forMethod
            
            if let body = withBody {
                var json = body.convertToJSON()
                var error:NSError?
                var jsonData = NSJSONSerialization.dataWithJSONObject(json, options: NSJSONWritingOptions.PrettyPrinted, error: &error)
                if let data = jsonData {
                    mutableRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    mutableRequest.HTTPBody = data
                    mutableRequest.setValue("\(data.length)", forHTTPHeaderField: "Content-Length")
                }
            }
            
            self.request = mutableRequest as NSURLRequest;
            self.conn = NSURLConnection(request: mutableRequest, delegate: self, startImmediately: self.startImmediately)
            success = self.conn != nil
            self.started = self.startImmediately && success
        }
        
        if !success {
            self.callback(request: self.request, response: RestResponse.CouldNotConnectToURL(toUrl.description))
        }
        return success
    }
    
    public func configureForGet(fromUrl: URLAndParameters) -> Bool {
        return self.connect(fromUrl, forMethod: "GET", withBody: nil)
    }
    
    public func configureForPost(fromUrl: URLAndParameters, data:SerializableToJSON) -> Bool {
        return self.connect(fromUrl, forMethod: "POST", withBody: data)
    }
    
    func connection(connection: NSURLConnection!, didReceiveResponse response: NSURLResponse) {
        self.response = response as? NSHTTPURLResponse
        self.data.length = 0;
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData) {
        self.data.appendData(data)
    }
    
    func connection(connection: NSURLConnection!, didFailWithError error: NSError) {
        self.callback(request: self.request, response: RestResponse.SystemFailure(error))
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        var restResponse: RestResponse = RestResponse.HTTPStatusCodeFailure(0, "no HTTP response received");
        
        if let httpResponse = self.response {
            if (httpResponse.statusCode >= 200 && httpResponse.statusCode < 300) {
                var shouldHaveData = false
                if self.data.length != 0 {
                    if let jsonString = NSString(data: self.data, encoding: NSUTF8StringEncoding) {
                        var s = jsonString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                        shouldHaveData = countElements(s) > 0
                    }
                }
                
                var result:JSON?
                var jsonErrorOptional: NSError?
                if (shouldHaveData) {
                    result = NSJSONSerialization.JSONObjectWithData(self.data, options: NSJSONReadingOptions(0), error: &jsonErrorOptional)
                }
                
                var localizedString = NSHTTPURLResponse.localizedStringForStatusCode(httpResponse.statusCode)
                restResponse = RestResponse.Success(httpResponse.statusCode, localizedString, result)
                
                if let error = jsonErrorOptional {
                    restResponse = RestResponse.JSONSerializationFailure(error)
                }
            } else {
                restResponse = RestResponse.HTTPStatusCodeFailure(httpResponse.statusCode, httpResponse.description)
            }
        }
        
        self.callback(request: self.request, response: restResponse)
    }

    
    public var isStarted: Bool { get { return self.started } }
    
    public func start() -> Bool {
        if self.started { return true }
        
        if let conn = self.conn {
            conn.start()
            self.started = true
        }
        
        return self.started
    }
    
    public func cancel() -> Bool {
        if let conn = self.conn {
            conn.cancel();
            return true;
        }
        
        return false;
    }
    
}