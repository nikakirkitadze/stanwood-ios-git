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
    
    var viewModel: TrendingRepositoryViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnOpenInGithub.layer.cornerRadius = 8
        representRepositoryInfo()
    }
    
    @IBAction func onOpenInGithub(_ sender: UIButton) {
        
    }
    
    private func representRepositoryInfo() {
        guard let viewModel = viewModel else {return}
        
        labelDescription.text = viewModel.descriptionn
    }
}
