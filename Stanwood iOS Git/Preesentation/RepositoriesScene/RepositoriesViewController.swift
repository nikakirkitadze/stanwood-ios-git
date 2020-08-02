
//
//  RepositoriesViewController.swift
//  Stanwood iOS Git
//
//  Created by Nika Kirkitadze on 7/30/20.
//  Copyright © 2020 Stanwood. All rights reserved.
//

import UIKit
import Reachability

class RepositoriesViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scFilter: UISegmentedControl!
    @IBOutlet weak var topMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelNoInternet: UILabel!
    
    internal var searchText: String?
    
    override func loadView() {
        super.loadView()
        view.addSubview(spinner)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        addObservers()
        fetchRepositories()
    }
    
    @IBAction func createdTypeSegment(_ sender: Any) {
        self.repositoryViewModelsFiltered.removeAll()
        self.repositoryViewModels.removeAll()
        self.spinner.startAnimating()
        self.fetchRepositories()
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
        if isNetwork {
            labelNoInternet.isHidden = true
            spinner.startAnimating()
            
            guard let created: CreatedType = CreatedType(rawValue: scFilter.selectedSegmentIndex) else {return}
            RepositoriesServiceManager.fetchRepositories(created) { (repos) in
                self.repositoryViewModels = repos.map({ RepositoryViewModel(item: $0) })
                DispatchQueue.main.async {
                    self.spinner.stopAnimating()
                    self.collectionView.reloadData()
                }
            }
        } else {
            spinner.stopAnimating()
            labelNoInternet.isHidden = false
        }
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reachabilityChanged(note:)),
                                               name: .reachabilityChanged,
                                               object: nil)
    }
    
    @objc func reachabilityChanged(note: Notification) {
        if isNetwork {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
            fetchRepositories()
        } else {
            let alert = UIAlertController(title: "Warning!", message: "No internet connection!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
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
        self.perform(#selector(search), with: nil, afterDelay: 0.3)
    }
    
    @objc func search() {
        guard let text = searchText else {return}
        spinner.startAnimating()
        
        RepositoriesServiceManager.searchRepository(with: text) { (data) in
            self.spinner.stopAnimating()
            self.repositoryViewModels.removeAll()
            self.repositoryViewModelsFiltered.removeAll()
            self.repositoryViewModels = data.map({ RepositoryViewModel(item: $0) })
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}
