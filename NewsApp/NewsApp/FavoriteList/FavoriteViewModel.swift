//
//  ViewModel.swift
//  NewsApp
//
//  Created by Mehmet ÖKSÜZ on 22.04.2024.
//

import Foundation

class FavoriteViewModel: BaseViewModel {
    
    let shared = FavoriteManager.shared
    
    func load() {
        let item = shared.get()
        self.present(item: item)
        self.didFinishLoad?()
    }
}
