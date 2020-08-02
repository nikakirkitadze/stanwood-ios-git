//
//  WebServiceOperation.swift
//  NetworkingLayer
//
//  Created by Nika Kirkitadze on 9/27/19.
//  Copyright © 2019 Nika Kirkitadze. All rights reserved.
//

import Foundation

class WebServiceOperation<T: Codable>: AsyncOperation {
    
    private var retry = 0
    var endPoint = ""
    enum HttpMethod : String {
        case GET, POST, HEAD, DELETE, PUT
    }
    var method:WebServiceOperation.HttpMethod {
        return .GET
    }
    var responseCompletionBlock: WebServiceManager.ResponseCompletionBlock<T>?
    
    private let logger: NetworkErrorLogger
    
    required override init() {
        self.logger = DefaultNetworkErrorLogger()
    }
    
    override func main() {
        guard let urlRequest = urlRequest() else {
            state = .isFinished
            return
        }
        let dataTask = WebServiceManager.shared.urlSession.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            guard let strongSelf = self else { return }
            if let response = response as? HTTPURLResponse {
                let responseObject: T? = strongSelf.responseObject(forData: data, response: response)
                
                if response.statusCode >= 200 && response.statusCode < 300 {
                    if let responseCompletionBlock = strongSelf.responseCompletionBlock {
                        strongSelf.dispatchOnMainQueue(responseCompletionBlock(.success(responseObject)))
                    }
                } else {
                    strongSelf.handleError(response: response, error: error, statusCode: response.statusCode)
                }
            } else {
                self?.handleError(response: response as? HTTPURLResponse,
                                  error:error,
                                  statusCode: -1)
            }
            
            strongSelf.state = .isFinished
        }
        
        // log
        Log.networkInfo(urlRequest)
        
        dataTask.resume()
    }
    
    private func responseObject<T: Codable>(forData data: Data?, response: HTTPURLResponse) -> T? {
        guard let data = data else {fatalError()}
        
        if data.isEmpty {
            return commonNetworkResponse(statusCode: response.statusCode) as? T
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch let err {
            Log.error(err)
        }
        
        return .none
    }
    
    func urlRequest() -> URLRequest? {
        guard let url = WebServiceManager.shared.url(withEndPoint: endPoint) else {
            return nil
        }
        
        guard let finalUrlString = url.absoluteString.removingPercentEncoding else {
            return nil
        }
        
        guard let newUrl = URL(string: finalUrlString) else {return nil}
        var urlRequest = URLRequest(url: newUrl)
        
        urlRequest.setValue(RequestHeaderFields.acceptEncoding.rawValue, forHTTPHeaderField: "gzip")
        urlRequest.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = self.method.rawValue
        
        return urlRequest
    }
    
    private func handleError(response: HTTPURLResponse?, error: Error?, statusCode: Int) {
        if let nsError = error as NSError?,
            self.canRetry(error: nsError),
            self.retry < 3 {
            self.retryOperation()
        } else if let responseCompletionBlock = responseCompletionBlock {
            if let error = error {
                dispatchOnMainQueue(responseCompletionBlock(.failure(.connectivityError(error, response))))
            } else if statusCode == 401 {
                dispatchOnMainQueue(responseCompletionBlock(.failure(.unauthenticated)))
            } else {
                var errorMessage = "An unknown error has occured"
                if statusCode == 500 {
                    errorMessage = "Internal Server Error"
                } else if statusCode == 503 {
                    errorMessage = "The server is currently unable to handle the request due to a temporary overload or scheduled maintenance"
                } else if statusCode == 404 {
                    errorMessage = "API endpoint not found"
                }
                dispatchOnMainQueue(responseCompletionBlock(.failure(.serverErrorWithMessage(errorMessage, response))))
            }
        }
    }
    
    private func dispatchOnMainQueue(_ closure: @escaping @autoclosure () -> Void) {
        DispatchQueue.main.async {
            closure()
        }
    }
    
    private func retryOperation() {
        WebServiceManager.shared.runRequest(operation: self.duplicateOperation())
    }
    
    func duplicateOperation() -> WebServiceOperation<T> {
        let operation = type(of: self).init()
        operation.endPoint = self.endPoint
        operation.retry = self.retry + 1
        operation.responseCompletionBlock = self.responseCompletionBlock
        
        return operation
    }
    
    private func canRetry(error:NSError) -> Bool {
        return (error.code == NSURLErrorCancelled) ||
            (error.code == NSURLErrorTimedOut) ||
            (error.code == NSURLErrorCannotFindHost) ||
            (error.code == NSURLErrorCannotConnectToHost) ||
            (error.code == NSURLErrorDNSLookupFailed) ||
            (error.code == NSURLErrorNetworkConnectionLost) ||
            (error.code == NSURLErrorNotConnectedToInternet)
    }
    
    private func commonNetworkResponse(statusCode: Int) -> NetworkResponse {
        return NetworkResponse(statusCode: statusCode, isSuccess: statusCode >= 200)
    }
}

struct NetworkResponse: Codable {
    let statusCode: Int
    let isSuccess: Bool
}

