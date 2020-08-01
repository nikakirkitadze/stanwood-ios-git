//
//  WebServiceManager.swift
//  NetworkingLayer
//
//  Created by Nika Kirkitadze on 9/27/19.
//  Copyright © 2019 Nika Kirkitadze. All rights reserved.
//

import Foundation

class WebServiceManager {
    
    static let shared = WebServiceManager()
    private init(){}
    
    private let operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.underlyingQueue = DispatchQueue(label: "stanwood.Stanwood-iOS-Git.webservice", attributes: .concurrent)
        return queue
    }()
    
    enum WebServiceError : Error {
        case errorFromServer(Error)
        case errorWithMessage(String)
        case unauthenticated
    }
    
    typealias ResponseCompletionBlock<T: Codable> = (Result<T?, NeoError>) -> Void
    var urlSession:URLSession = {
        return URLSession(configuration: URLSessionConfiguration.default)
    }()
    var baseUrl = URL(string: ApiConfiguration.baseUrl)
    
    func configure(with apiKey: String) {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 20
//        configuration.httpAdditionalHeaders = ["api_key": apiKey]
        self.urlSession = URLSession(configuration: configuration)
    }
    
    func setApiUrl(url: String) {
        baseUrl = URL(string: "https://\(url)")
    }
    
    func url(withEndPoint endpoint:String) -> URL? {
        if endpoint.hasPrefix("https") {
            return URL(string:endpoint)
        } else {
            guard let baseUrl = baseUrl else {
                return nil
            }
            return baseUrl.appendingPathComponent(endpoint)
        }
    }
    
    func get<T: Codable>(endpoint: String, params: [String:String] = [:], completion: @escaping ResponseCompletionBlock<T>) {
        let getOperation = GetWebServiceOperation<T>()
        getOperation.queryParams = params
        getOperation.endPoint = endpoint
        getOperation.responseCompletionBlock = completion
        self.runRequest(operation: getOperation)
    }
    
    func head<T: Codable>(endpoint: String, params: [String:String], completion: @escaping ResponseCompletionBlock<T>) {
        let headOperation = HeadWebServiceOperation<T>()
        headOperation.queryParams = params
        headOperation.endPoint = endpoint
        headOperation.responseCompletionBlock = completion
        self.runRequest(operation: headOperation)
    }
    
    func delete<T: Codable>(endpoint:String, params:[String:String], completion:@escaping ResponseCompletionBlock<T>) {
        let deleteOperation = DeleteWebServiceOperation<T>()
        deleteOperation.queryParams = params
        deleteOperation.endPoint = endpoint
        deleteOperation.responseCompletionBlock = completion
        self.runRequest(operation: deleteOperation)
    }
    
    func post<T: Codable>(endpoint:String, body:[String:Any], completion:@escaping ResponseCompletionBlock<T>) {
        let postOperation = PostWebServiceOperation<T>()
        postOperation.body = body
        postOperation.endPoint = endpoint
        postOperation.responseCompletionBlock = completion
        self.runRequest(operation: postOperation)
    }
    
    func put<T: Codable>(endpoint:String, body:[String:String], completion:@escaping ResponseCompletionBlock<T>) {
        let putOperation = PutWebServiceOperation<T>()
        putOperation.body = body
        putOperation.endPoint = endpoint
        putOperation.responseCompletionBlock = completion
        self.runRequest(operation: putOperation)
    }
    
    func runRequest<T: Codable>(operation: WebServiceOperation<T>) {
        self.operationQueue.addOperation(operation)
    }
}
