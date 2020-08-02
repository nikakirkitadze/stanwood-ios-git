//
//  BaseRepositoryViewController.swift
//  Stanwood iOS Git
//
//  Created by Nika Kirkitadze on 8/1/20.
//  Copyright © 2020 Stanwood. All rights reserved.
//

import UIKit

class BaseRepositoryViewController: UIViewController {
    
    internal var spinner: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .large)
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.startAnimating()
        return ai
    }()
    
    internal var repositoryViewModels = [RepositoryViewModel]()
    internal var currentRepositoryViewModel: RepositoryViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.Details {
            guard let destinationVC = segue.destination as? DetailsViewController else {return}
            destinationVC.viewModel = currentRepositoryViewModel
        }
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

// MARK: UICollectionViewDataSource
extension BaseRepositoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return repositoryViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.deque(RepositoryCell.self, for: indexPath)
        cell.maxWidth = view.frame.width
        cell.configure(with: repositoryViewModels[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension BaseRepositoryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentRepositoryViewModel = repositoryViewModels[indexPath.row]
        performSegue(withIdentifier: Segues.Details, sender: nil)
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension BaseRepositoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 75)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
