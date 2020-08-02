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
    
    @IBOutlet weak var maxWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    internal var maxWidth: CGFloat? = nil {
        didSet {
            guard let maxWidth = maxWidth else {
                return
            }
            maxWidthConstraint.isActive = true
            maxWidthConstraint.constant = maxWidth
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imgUser.layer.cornerRadius = imgUser.frame.height/2
    }
    
    internal func configure(with viewModel: RepositoryViewModel) {
        labelUsername.text      = viewModel.authorAndName
        labelDescription.text   = viewModel.descriptionn
        imgUser.kf.setImage(with: viewModel.avatarUrl)
    }

}
