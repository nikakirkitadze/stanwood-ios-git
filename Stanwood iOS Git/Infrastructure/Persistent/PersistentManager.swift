//
//  DataManager.swift
//  Stanwood iOS Git
//
//  Created by Nika Kirkitadze on 8/2/20.
//  Copyright © 2020 Stanwood. All rights reserved.
//

import Foundation
import CoreData

class PersistentManager {
    
    static let shared = PersistentManager()
    private init() {
        createRepositoriesDir()
    }
    
    let fm = FileManager.default
    private var mainPath: URL {
        return try! fm.url(for: .applicationSupportDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
    }
    
    private var repositoriesPath: URL {
        return mainPath.appendingPathComponent("repositories")
    }
    
    private func createRepositoriesDir() {
        try? fm.createDirectory(at: repositoriesPath, withIntermediateDirectories: true, attributes: [:])
    }
    
    func save(repository: Repository) {
        // create url
        let url = repositoriesPath.appendingPathComponent("repo_\(repository.id).json")
        
        do {
            let encoder = JSONEncoder()
            let encoded = try encoder.encode(repository)
            try encoded.write(to: url, options: .atomicWrite)
            NotificationCenter.default.post(name: .didMarkRepository, object: nil)
        } catch let err {Log.error(err)}
    }
    
    func fetch(completion: @escaping ([Repository]) -> ()) {
        // contents of dir
        guard let dirUrls = try? fm.contentsOfDirectory(at: repositoriesPath, includingPropertiesForKeys: nil, options: .skipsHiddenFiles) else {return}
        
        var repositories = [Repository]()
        for url in dirUrls {
            do {
                let jsonData = try Data(contentsOf: url)
                let decoded = try JSONDecoder().decode(Repository.self, from: jsonData)
                repositories.append(decoded)
            } catch let err {Log.error(err)}
        }
        
        completion(repositories)
    }
    
    func delete(repository: Repository) {
        let file = "repo_\(repository.id).json"
        
        do {
            try fm.removeItem(at: repositoriesPath.appendingPathComponent(file))
        } catch let err {Log.error(err)}
    }

    func parse(url: URL) -> Repository? {
        
        do {
            let jsonData = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode(Repository.self, from: jsonData)
        } catch let err {Log.error(err)}
        
        return nil
    }
}
