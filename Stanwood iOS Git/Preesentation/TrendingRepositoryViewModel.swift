//
//  TrendingRepositoryViewModel.swift
//  Stanwood iOS Git
//
//  Created by Nika Kirkitadze on 8/1/20.
//  Copyright © 2020 Stanwood. All rights reserved.
//

import Foundation

struct TrendingRepositoryViewModel {
    
    internal var authorAndName: String
    internal var descriptionn: String
    private var avatar: String
    
    internal var avatarUrl: URL? {
        return URL(string: avatar)
    }
    
    // DI
    init(item: TrendingRepository) {
        authorAndName   = "\(item.author)/\(item.name)"
        descriptionn    = item.financialConditionResponseDescription ?? ""
        avatar          = item.avatar
    }
}
