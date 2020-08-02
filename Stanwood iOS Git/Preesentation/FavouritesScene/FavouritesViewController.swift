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

        
        configureSearchBar()
        configureCollectionView()
        fetchRepositories()
        addObservers()
    }

    private func configureSearchBar() {
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.delegate = self
        self.navigationItem.searchController = search
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
        self.repositoryViewModelsFiltered.removeAll()
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

// MARK: UISearchBarDelegate
extension FavouritesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        repositoryViewModelsFiltered.removeAll()
        guard let text = searchBar.text?.lowercased() else {return}
        if text.isEmpty {repositoryViewModelsFiltered.append(contentsOf: repositoryViewModels)}
        
        for repoViewModel in repositoryViewModels {
            let targetText = "\(repoViewModel.authorAndName.lowercased()) \(repoViewModel.descriptionn.lowercased())"
            if targetText.contains(text) {
                repositoryViewModelsFiltered.append(repoViewModel)
            }
        }
        
        self.collectionView.reloadData()
    }
}
