//
//  FavouritesViewController.swift
//  Stanwood iOS Git
//
//  Created by Nika Kirkitadze on 7/30/20.
//  Copyright © 2020 Stanwood. All rights reserved.
//

import UIKit

class FavouritesViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func loadView() {
        super.loadView()
        view.addSubview(spinner)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()
        fetchRepositories()
        addObservers()
    }

    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(RepositoryCell.self)
    }

    private func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(fetchRepositories),
                                               name: .didMarkRepository,
                                               object: nil)
    }
    
    @objc func fetchRepositories() {
        self.repositoryViewModels.removeAll()
        PersistentManager.shared.fetch { (data) in
            
            self.repositoryViewModels = data.map({
                var rep = RepositoryViewModel(item: $0)
                rep.isFavourite = true
                return rep
            })

            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                self.collectionView.reloadData()
            }
        }
    }
    
    override func repositoryDidRemoved(index: Int) {
        super.repositoryDidRemoved(index: index)
        self.collectionView.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
