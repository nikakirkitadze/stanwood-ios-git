//
//  PostWebServiceOperation.swift
//  NetworkingLayer
//
//  Created by Nika Kirkitadze on 9/27/19.
//  Copyright © 2019 Nika Kirkitadze. All rights reserved.
//

import Foundation

class PostWebServiceOperation<T: Codable> : WebServiceOperation<T> {
    
    var body: [String:Any] = [:]
    
    override var method:WebServiceOperation<T>.HttpMethod {
        return .POST
    }
    
    override func urlRequest() -> URLRequest? {
        guard var urlRequest = super.urlRequest() else { return nil }
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let data = try? JSONSerialization.data(withJSONObject: body, options: []) {
            urlRequest.httpBody = data
        }
        
        return urlRequest
    }
    
    override func duplicateOperation() -> WebServiceOperation<T> {
        let operation = super.duplicateOperation()
        
        if let postOperation = operation as? PostWebServiceOperation {
            postOperation.body = self.body
        }
        
        return operation
    }
}
