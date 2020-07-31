//
//  RepositoryCell.swift
//  Stanwood iOS Git
//
//  Created by Nika Kirkitadze on 7/30/20.
//  Copyright © 2020 Stanwood. All rights reserved.
//

import UIKit
import Kingfisher

class RepositoryCell: UICollectionViewCell {
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var labelDescription: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
