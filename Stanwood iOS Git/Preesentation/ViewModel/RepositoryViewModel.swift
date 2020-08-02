//
//  RepositoryViewModel.swift
//  Stanwood iOS Git
//
//  Created by Nika Kirkitadze on 8/1/20.
//  Copyright © 2020 Stanwood. All rights reserved.
//

import UIKit
import Foundation

struct RepositoryViewModel {
    
    // MARK: Internal properties
    internal var id: Int
    internal var authorAndName: String
    internal var descriptionn: String
    internal var language: String
    internal var forks: String
    internal var stars: String
    internal var repository: Repository
    
    internal var avatarUrl: URL? {
        return URL(string: avatar)
    }
    
    internal var repoUrl: URL? {
        return URL(string: htmlUrl)
    }
    
    // flag
    internal var isFavourite: Bool = false
    
    // MARK: Private properties
    private var avatar: String
    private var htmlUrl: String
    private var createdAt: String
    
    // MARK: Computed
    internal var formattedDate: String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        guard let date = formatter.date(from: createdAt) else {
            return ""
        }
        
        let df = DateFormatter()
        df.dateFormat = "MM/dd/yyyy"
        return "Created \(date.timeAgoDisplay()) at \(df.string(from: date))"
    }
    
    internal var favouriteIcon: UIImage? {
        return isFavourite ? UIImage(named: "ic-bookmark-selected") : UIImage(named: "ic-bookmark")
    }
    
    // DI
    init(item: Repository) {
        repository      = item
        id              = item.id
        authorAndName   = item.fullName ?? ""
        descriptionn    = item.repositoryDescription ?? ""
        language        = item.language ?? ""
        forks           = "\(item.forks ?? 0) Forks"
        stars           = "\(item.stargazersCount ?? 0) Stars"
        createdAt       = item.createdAt ?? ""
        htmlUrl         = item.htmlURL ?? ""
        avatar          = item.owner.avatarURL ?? ""
    }
}
