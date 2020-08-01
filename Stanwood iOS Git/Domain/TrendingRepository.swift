//
//  TrendingRepository.swift
//  Stanwood iOS Git
//
//  Created by Nika Kirkitadze on 8/1/20.
//  Copyright © 2020 Stanwood. All rights reserved.
//

import Foundation

// MARK: - TrendingRepository
struct TrendingRepository: Codable {
    let author, name: String
    let avatar: String
    let url: String
    let financialConditionResponseDescription, language, languageColor: String?
    let stars, forks, currentPeriodStars: Int
    let builtBy: [BuiltBy]

    enum CodingKeys: String, CodingKey {
        case author, name, avatar, url
        case financialConditionResponseDescription = "description"
        case language, languageColor, stars, forks, currentPeriodStars, builtBy
    }
}

// MARK: - BuiltBy
struct BuiltBy: Codable {
    let username: String
    let href, avatar: String
}
