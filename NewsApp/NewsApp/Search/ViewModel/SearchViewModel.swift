//
//  SearchViewModel.swift
//  NewsApp
//
//  Created by Mehmet ÖKSÜZ on 16.04.2024.
//

import Foundation

class SearchViewModel: BaseViewModel {
    
    func searchResponse(query: String) {
        
        guard let url = URL(string: "https://newsapi.org/v2/everything?q=\(query)&apiKey=\(LocaleKey.API_KEY)"
        ) else {
            print("Invali URL")
            return
            
        }
        
        WebService.shared.fetchRequest(from: url) { (result: Result<NewsModelResponse,Error>) in
            switch result {
            case .success(let success):
                self.present(item: success.articles)
            case .failure(let failure):
                self.didFinishLoadWithError?(failure.localizedDescription)
            }
        }
    }
    
    func clearResults() {
        news.removeAll()
    }
}
