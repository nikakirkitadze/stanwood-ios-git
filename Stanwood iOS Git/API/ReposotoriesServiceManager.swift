//
//  ReposotoriesServiceManager.swift
//  Stanwood iOS Git
//
//  Created by Nika Kirkitadze on 8/1/20.
//  Copyright © 2020 Stanwood. All rights reserved.
//

import Foundation

class RepositoriesServiceManager {
    
    static func searchRepository(with searchTerm: String, completion: @escaping ([Repository]) -> ()) {
        var urlComponents = URLComponents()
        urlComponents.path = "search/repositories"
        urlComponents.queryItems = [
           URLQueryItem(name: "q", value: searchTerm),
           URLQueryItem(name: "page", value: "1"),
           URLQueryItem(name: "per_page", value: "10")
        ]
        
        guard let absoluteString = urlComponents.url?.absoluteString else {return}
        WebServiceManager.shared.get(endpoint: absoluteString) { (result: Result<RepositoryReponse?, NeoError>) in
            switch result {
            case .success(let repos):
                guard let repos = repos else {return}
                completion(repos.items ?? [])
            case .failure(let err):
                print(err)
            }
        }
    }
    
    static func fetchRepositories(since: String = "1", completion: @escaping ([Repository]) -> ()) {
        var urlComponents = URLComponents()
        urlComponents.path = "repositories"
        urlComponents.queryItems = [
           URLQueryItem(name: "since", value: ":=1")
        ]
        
        let url = self.urlWithParameters(url: "repositories", parameters: ["since":"1"])
        
        guard let absoluteString = urlComponents.url?.absoluteString else {return}
        WebServiceManager.shared.get(endpoint: url) { (result: Result<[Repository]?, NeoError>) in
            switch result {
            case .success(let repos):
                guard let repos = repos else {return}
                completion(repos)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    static func urlWithParameters(url: String, parameters: [String:String]?) -> String {
        var retUrl = url
        if let parameters = parameters {
            if parameters.count > 0 {
                retUrl.append("?")
                parameters.keys.forEach {
                    guard let value = parameters[$0] else { return }
                    let escapedValue = value.addingPercentEncoding(withAllowedCharacters: CharacterSet.BaseAPI_URLQueryAllowedCharacterSet())
                    if let escapedValue = escapedValue {
                        retUrl.append("\($0)=\(escapedValue)&")
                    }
                }
                retUrl.removeLast()
            }
        }
        return retUrl
    }
}
