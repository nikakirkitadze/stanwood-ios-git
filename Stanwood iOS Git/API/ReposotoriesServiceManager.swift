//
//  ReposotoriesServiceManager.swift
//  Stanwood iOS Git
//
//  Created by Nika Kirkitadze on 8/1/20.
//  Copyright © 2020 Stanwood. All rights reserved.
//

import Foundation

enum CreatedType: Int {
    case day = 0
    case month
    case year
}

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
    
    static func fetchRepositories(for page: Int, _ created: CreatedType, completion: @escaping ([Repository]) -> ()) {
        var urlComponents = URLComponents()
        urlComponents.path = "search/repositories"
        urlComponents.queryItems = [
           URLQueryItem(name: "q", value: "created:>\(getDate(created))"),
           URLQueryItem(name: "page", value: "\(page)"),
           URLQueryItem(name: "per_page", value: "20"),
           URLQueryItem(name: "sort", value: "stars"),
           URLQueryItem(name: "order", value: "desc")
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
    
    static func getDate(_ type: CreatedType) -> String {
        var dayComponent    = DateComponents()
        switch type {
        case .day:
            dayComponent.day    = -1
        case .month:
            dayComponent.month  = -1
        case .year:
            dayComponent.year   = -1
        }
        let theCalendar     = Calendar.current
        let previousDate    = theCalendar.date(byAdding: dayComponent, to: Date())
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = previousDate else {return ""}
        return dateFormatter.string(from: date)
    }
}
