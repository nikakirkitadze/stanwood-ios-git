//
//  ReposotoriesServiceManager.swift
//  Stanwood iOS Git
//
//  Created by Nika Kirkitadze on 8/1/20.
//  Copyright © 2020 Stanwood. All rights reserved.
//

import Foundation

class RepositoriesServiceManager {
    static func fetchTrendingRepositories(completion: @escaping ([TrendingRepository]) -> ()) {
        WebServiceManager.shared.get(endpoint: "") { (result: Result<[TrendingRepository]?, NeoError>) in
            switch result {
            case .success(let repos):
                guard let repos = repos else {return}
                completion(repos)
            case .failure(let err):
                print(err)
            }
        }
    }
}
