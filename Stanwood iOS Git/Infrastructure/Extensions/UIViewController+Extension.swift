//
//  UIViewController+Extension.swift
//  Stanwood iOS Git
//
//  Created by Nika Kirkitadze on 8/2/20.
//  Copyright © 2020 Stanwood. All rights reserved.
//

import UIKit

extension UIViewController {
    var isNetwork: Bool {
        return AppDelegate.shared.reachability?.connection != .unavailable
    }
}
