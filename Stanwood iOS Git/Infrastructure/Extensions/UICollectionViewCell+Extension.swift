//
//  UICollectionViewCell+Extension.swift
//  Stanwood iOS Git
//
//  Created by Nika Kirkitadze on 7/30/20.
//  Copyright © 2020 Stanwood. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    static var identifier = String(describing: self)
    
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle.main)
    }
}
