//
//  EndPointer.swift
//  NewsApp
//
//  Created by Mehmet ÖKSÜZ on 4.04.2024.
//

import Foundation

enum NewsAPIEndpoint {
    case topHeadlines
    case appleNews
    case finance
    case featured
    case science
    case search(query: String)
    case sports
    case gaming
    case tech
    case politics
    case fashion
    case cinema
    case arts
    
    private static let baseURL = "https://newsapi.org/v2/"
    
    var url: URL? {
        var urlString = NewsAPIEndpoint.baseURL
        switch self {
        case .topHeadlines:
            urlString += "top-headlines?country=us"
        case .appleNews:
            urlString += "everything?q=apple&from=2023-11-25&to=2023-11-25&sortBy=popularity"
        case .finance:
            urlString += "everything?q=finance"
        case .featured:
            urlString += "everything?q=bitcoin"
        case .science:
            urlString += "everything?q=science"
        case .search(let query):
            urlString += "everything?q=\(query)"
        case .sports:
            urlString += "everything?q=sports"
        case .gaming:
            urlString += "everything?q=gaming"
        case .tech:
            urlString += "everything?q=technology"
        case .politics:
            urlString += "everything?q=politics"
        case .fashion:
            urlString += "everything?q=fashion"
        case .cinema:
            urlString += "everything?q=cinema"
        case .arts:
            urlString += "everything?q=arts"
        }
        urlString += "&apiKey=\(LocaleKey.API_KEY)"
        return URL(string: urlString)
    }
}



