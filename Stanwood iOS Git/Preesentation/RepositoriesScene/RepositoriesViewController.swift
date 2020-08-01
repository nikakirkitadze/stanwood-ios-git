
//
//  RepositoriesViewController.swift
//  Stanwood iOS Git
//
//  Created by Nika Kirkitadze on 7/30/20.
//  Copyright © 2020 Stanwood. All rights reserved.
//

import UIKit

class RepositoriesViewController: BaseRepositoryViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scFilter: UISegmentedControl!
    
    override func loadView() {
        super.loadView()
        view.addSubview(spinner)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        fetchRepositories()
    }
    
    private func setupLayout() {
        //selected title text color
        scFilter.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.selected)
        //default title text color
        scFilter.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.darkGray], for: UIControl.State.normal)
        
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(RepositoryCell.self)
    }
    
    private func fetchRepositories() {
        RepositoriesServiceManager.fetchTrendingRepositories { (repos) in
            self.trendingReposViewModels = repos.map({ TrendingRepositoryViewModel(item: $0) })
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                self.collectionView.reloadData()
            }
        }
    }
}
