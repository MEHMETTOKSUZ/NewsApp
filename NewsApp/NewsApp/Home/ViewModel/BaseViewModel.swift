//
//  BaseViewModel.swift
//  NewsApp
//
//  Created by Mehmet ÖKSÜZ on 7.04.2024.
//

import Foundation

class BaseViewModel {
    
    var didFinishLoad: (() -> Void)?
    var didFinishLoadWithError: ((String) -> Void)?
    var news: [HomeCollectionViewCell.ViewModel] = []
    
    var numberOfItemInSection: Int {
        return news.count
    }
    
    func item(at index: Int) -> HomeCollectionViewCell.ViewModel? {
        guard index >= 0, index < news.count else {
            return nil
        }
        return news[index]
    }
    
    
    func present(item: [Article]) {
        let viewModel: [HomeCollectionViewCell.ViewModel] = item.map { results in
            HomeCollectionViewCell.ViewModel(response: results)
        }
        self.news = viewModel
        self.didFinishLoad?()
    }
}
