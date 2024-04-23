//
//  FavoriteViewController.swift
//  NewsApp
//
//  Created by Mehmet ÖKSÜZ on 22.04.2024.
//

import UIKit
import SafariServices

class FavoriteViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let viewModel = FavoriteViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCollectionCells()
        NotificationCenter.default.addObserver(self, selector: #selector(loadFavorite), name: NSNotification.Name(rawValue: "notifications"), object: nil)
        viewModel.didFinishLoad = { [weak self] in
            self?.collectionView.reloadData()
        }
        viewModel.load()
    }
    
    @objc func loadFavorite() {
        
        viewModel.load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.reloadData()
        
    }
    
    func registerCollectionCells() {
        
        let nibName = UINib(nibName: "NewsCollectionViewCell", bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: "NewsCollectionViewCell")
    }
}

extension FavoriteViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.numberOfItemInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCollectionViewCell", for: indexPath) as! NewsCollectionViewCell
        guard let data = viewModel.item(at: indexPath.row) else {
            return cell
        }
        
        cell.itemFromCell(item: data)
        
        cell.favoriteButtonClicked = {
            FavoriteManager.shared.delete(item: data.data)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.bounds.width
        let cellSize = width / 2 - 15
        return CGSize(width: cellSize, height: cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let selectedItem = viewModel.item(at: indexPath.row) else {
            return
        }
        let urlString = selectedItem.url ?? ""
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
        
    }
}
