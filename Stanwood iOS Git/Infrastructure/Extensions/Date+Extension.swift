//
//  Date+Extension.swift
//  Stanwood iOS Git
//
//  Created by Nika Kirkitadze on 8/2/20.
//  Copyright © 2020 Stanwood. All rights reserved.
//

import Foundation

extension Date {
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
