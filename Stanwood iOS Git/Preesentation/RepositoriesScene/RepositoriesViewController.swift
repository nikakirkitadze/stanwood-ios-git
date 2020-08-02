
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
    
    var isLoading = false
    var hasNextPage = false
    var paginated = false
    var currentPage = 1
    let paginationIndicatorInset: CGFloat = 25
    
    override func loadView() {
        super.loadView()
        view.addSubview(spinner)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        addObservers()
        
        paginated = true
        load(page: 1)
    }
    
    @IBAction func createdTypeSegment(_ sender: Any) {
        self.repositoryViewModelsFiltered.removeAll()
        self.repositoryViewModels.removeAll()
        self.spinner.startAnimating()
        self.load(page: currentPage)
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
    
    func load(page: Int) {
        guard !isLoading else { return }
        isLoading = true
        hasNextPage = false
        
        if isNetwork {
            labelNoInternet.isHidden = true
            
            guard let created: CreatedType = CreatedType(rawValue: scFilter.selectedSegmentIndex) else {return}
            RepositoriesServiceManager.fetchRepositories(for: page, created) { (repos) in
                self.isLoading = false
                self.repositoryViewModels = repos.map({ RepositoryViewModel(item: $0) })
                
                if repos.isEmpty {
                    self.collectionView.contentInset.bottom = self.tabBarController?.tabBar.frame.height ?? 0
                } else {
                    self.hasNextPage = true
                }
                
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
            
            load(page: currentPage)
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
        slideTopComponents(scrollView)
        pagination(scrollView)
    }
    
    private func pagination(_ scrollView: UIScrollView) {
        guard paginated else { return }
        let y = scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentInset.bottom
        let height = scrollView.contentSize.height
        let reloadDistance: CGFloat = 10
        if y > height + reloadDistance && !isLoading && hasNextPage {
            let inset = tabBarController?.tabBar.frame.height ?? 0
            collectionView.contentInset.bottom = inset + paginationIndicatorInset
            
            let background = UIView(frame: collectionView.bounds)
            let indicator = UIActivityIndicatorView(style: .large)
            
            indicator.startAnimating()
            background.addSubview(indicator)
            
            indicator.center = background.center
            indicator.frame.origin.y = background.frame.height - indicator.frame.height - 15
            
            collectionView.backgroundView = background
            
            // wait two seconds to simulate some work happening
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                // then remove the spinner view controller
                background.removeFromSuperview()
            }
            
            currentPage += 1
            load(page: currentPage)
        }
    }
    
    private func slideTopComponents(_ scrollView: UIScrollView) {
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
