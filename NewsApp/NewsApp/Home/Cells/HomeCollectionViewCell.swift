//
//  HomeCollectionViewCell.swift
//  NewsApp
//
//  Created by Mehmet ÖKSÜZ on 7.04.2024.
//

import UIKit

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    struct ViewModel {
        
        let source: Source
        let title: String
        let description: String?
        let url: String?
        let urlToImage: String?
        let publishedAt: String
        let data: Article
        
        var isFavorite: Bool {
            FavoriteManager.shared.isFavorite(item: data)
        }
        
        var formattedPublishedAt: String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            guard let date = dateFormatter.date(from: publishedAt) else {
                return publishedAt
            }
            
            let now = Date()
            let difference = Calendar.current.dateComponents([.minute], from: date, to: now)
            
            if let minutes = difference.minute, minutes > 0 {
                return "\(minutes) dakika önce"
            } else {
                return "Şimdi"
            }
        }
    }
}

extension HomeCollectionViewCell.ViewModel {
    init(response: Article) {
        
        self.init(source: response.source,
                  title: response.title,
                  description: response.description,
                  url: response.url,
                  urlToImage: response.urlToImage,
                  publishedAt: response.publishedAt,
                  data: response)
    }
}
