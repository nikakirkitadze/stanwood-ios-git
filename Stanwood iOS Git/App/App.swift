//
//  App.swift
//  Stanwood iOS Git
//
//  Created by Nika Kirkitadze on 8/1/20.
//  Copyright © 2020 Stanwood. All rights reserved.
//

import Foundation

public class App {
    public static func configure(withApiKey apiKey: String? = nil, withApiUrl url: String? = nil) {
        if let apiKey = apiKey {
            WebServiceManager.shared.configure(with: apiKey)
        }
        
        if let apiUrl = url {
            WebServiceManager.shared.setApiUrl(url: apiUrl)
        }
    }
}
