//
//  ViewModel.swift
//  NewsApp
//
//  Created by Mehmet ÖKSÜZ on 7.04.2024.
//

import Foundation

class ViewModel: BaseViewModel {
    
    func makeRequest(for menuItem: String) {
        var endpoint: NewsAPIEndpoint
        
        switch menuItem {
        case "Top Head Lines":
            endpoint = .topHeadlines
        case "Notifications":
            endpoint = .finance
        case "Featured":
            endpoint = .featured
        case "Science":
            endpoint = .science
        case "Sports":
            endpoint = .sports
        case "Gaming":
            endpoint = .gaming
        case "Technology":
            endpoint = .tech
        case "Politics":
            endpoint = .politics
        case "Fashion":
            endpoint = .fashion
        case "Cinema":
            endpoint = .cinema
        case "Arts":
            endpoint = .arts
        case "Search":
            endpoint = .search(query: "")
        default:
            endpoint = .topHeadlines
        }
        
        guard let url = endpoint.url else {
            print("Invalid URL for \(menuItem)")
            return
        }
        
        WebService.shared.fetchRequest(from: url) { [weak self] (result: Result<NewsModelResponse, Error>) in
            switch result {
            case .success(let success):
                self?.present(item: success.articles)
            case .failure(let failure):
                self?.didFinishLoadWithError?(failure.localizedDescription)
            }
        }
    }
    
    func clearResults() {
        news.removeAll()
    }
}

