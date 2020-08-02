//
//  Notification.Name+Extensions.swift
//  Stanwood iOS Git
//
//  Created by Nika Kirkitadze on 8/2/20.
//  Copyright © 2020 Stanwood. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let didMarkRepository    = Notification.Name(rawValue: "didMarkRepository")
    static let flagsChanged         = Notification.Name(rawValue: "FlagsChanged")
}
