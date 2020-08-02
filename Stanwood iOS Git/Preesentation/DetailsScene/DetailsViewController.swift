//
//  DetailsViewController.swift
//  Stanwood iOS Git
//
//  Created by Nika Kirkitadze on 7/31/20.
//  Copyright © 2020 Stanwood. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelLanguage: UILabel!
    @IBOutlet weak var labelFork: UILabel!
    @IBOutlet weak var labelStar: UILabel!
    @IBOutlet weak var labelCreatedDate: UILabel!
    @IBOutlet weak var btnOpenInGithub: UIButton!
    
    var viewModel: RepositoryViewModel?
    private var linkUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnOpenInGithub.layer.cornerRadius = 8
        representRepositoryInfo()
    }
    
    @IBAction func onOpenInGithub(_ sender: UIButton) {
        guard let url = linkUrl else {
            return
        }
            
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    private func representRepositoryInfo() {
        guard let viewModel     = viewModel else {return}
        linkUrl                 = viewModel.repoUrl
        
        labelDescription.text   = viewModel.descriptionn
        labelLanguage.text      = viewModel.language
        labelFork.text          = viewModel.forks
        labelStar.text          = viewModel.stars
        labelCreatedDate.text   = viewModel.formattedDate
    }
}
