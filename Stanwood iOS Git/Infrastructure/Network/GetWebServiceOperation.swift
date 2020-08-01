//
//  GetWebServiceOperation.swift
//  NetworkingLayer
//
//  Created by Nika Kirkitadze on 9/27/19.
//  Copyright © 2019 Nika Kirkitadze. All rights reserved.
//

import Foundation

class GetWebServiceOperation<T: Codable>: WebServiceOperation<T> {
    var queryParams = [String:String]()
 
    override func urlRequest() -> URLRequest? {
        guard var urlRequest = super.urlRequest() else {
            return nil
        }
        
        let generalDelimitersToEncode = ":#[]@/"
        let subDelimitersToEncode = "!$&'()*+,;=."
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        
        let pairs = queryParams.map { (item) -> String in
            guard let value = item.value.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)?
                .replacingOccurrences(of: "%0A", with: "\n")
                .replacingOccurrences(of: "%0D", with: "\r") else { return "\(item.key)="}
            return "\(item.key)=\(value)"
        }
        
        let queryString = "?" + pairs.joined(separator: "&")
        
        if let fullUrlString = urlRequest.url?.absoluteString,
            let fullUrl = URL(string:fullUrlString + queryString){
            urlRequest.url = fullUrl
        }
        
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        
        return urlRequest
    }
    
    override func duplicateOperation() -> WebServiceOperation<T> {
        let operation = super.duplicateOperation()
        
        if let getOperation = operation as? GetWebServiceOperation {
            getOperation.queryParams = self.queryParams
        }
        
        return operation
    }
}
