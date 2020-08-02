//
//  RepositoryCell.swift
//  Stanwood iOS Git
//
//  Created by Nika Kirkitadze on 7/30/20.
//  Copyright © 2020 Stanwood. All rights reserved.
//

import UIKit
import Kingfisher

@objc protocol RepositoryCellDelegate: class {
    func repositoryDidRemoved(index: Int)
}

class RepositoryCell: UICollectionViewCell {
    
    @IBOutlet weak var maxWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var btnFavourite: UIButton!
    
    internal var maxWidth: CGFloat? = nil {
        didSet {
            guard let maxWidth = maxWidth else {
                return
            }
            maxWidthConstraint.isActive = true
            maxWidthConstraint.constant = maxWidth
        }
    }
    
    private var viewModel: RepositoryViewModel?
    internal var row: Int = -1
    
    weak var delegate: RepositoryCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imgUser.layer.cornerRadius = imgUser.frame.height/2
    }
    
    @IBAction func onBookmark(_ sender: UIButton) {
        guard var viewModel = viewModel else {return}

        if viewModel.isFavourite {
            PersistentManager.shared.delete(repository: viewModel.repository)
            delegate?.repositoryDidRemoved(index: row)
        } else {
            PersistentManager.shared.save(repository: viewModel.repository)
        }
        
        viewModel.isFavourite.toggle()
        sender.setImage(viewModel.favouriteIcon, for: .normal)
        
        // haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    internal func configure(with viewModel: RepositoryViewModel) {
        self.viewModel = viewModel
        labelUsername.text      = viewModel.authorAndName
        labelDescription.text   = viewModel.descriptionn
        imgUser.kf.setImage(with: viewModel.avatarUrl)
        btnFavourite.setImage(viewModel.favouriteIcon, for: .normal)
    }

}
