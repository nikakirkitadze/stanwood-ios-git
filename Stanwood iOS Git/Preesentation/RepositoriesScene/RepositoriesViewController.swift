
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
    @IBOutlet weak var topMarginConstraint: NSLayoutConstraint!
    
    internal var searchText: String?
    
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
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.delegate = self
        self.navigationItem.searchController = search
        
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
        RepositoriesServiceManager.fetchRepositories { (repos) in
            self.repositoryViewModels = repos.map({ RepositoryViewModel(item: $0) })
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                self.collectionView.reloadData()
            }
        }
    }
}

// MARK: UIScrollViewDelegate
extension RepositoriesViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        if bottomEdge >= scrollView.contentSize.height {
            // we are at the end
            return
        }
        
        if scrollView.contentOffset.y > 10 {
            print(scrollView.contentOffset.y)
            topMarginConstraint.constant = -scrollView.contentOffset.y - 10
            self.view.layoutIfNeeded()
        } else {
            topMarginConstraint.constant = 45
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: UISearchBarDelegate
extension RepositoriesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchBar.text
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(search), object: nil)
        self.perform(#selector(search), with: nil, afterDelay: 0.5)
    }

    @objc func search() {
        guard let text = searchText else {return}
        spinner.startAnimating()
        
        RepositoriesServiceManager.searchRepository(with: text) { (data) in
            self.spinner.stopAnimating()
            self.repositoryViewModels.removeAll()
            self.repositoryViewModels = data.map({ RepositoryViewModel(item: $0) })
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}
