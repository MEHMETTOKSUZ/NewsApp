//
//  FavoriteManager.swift
//  NewsApp
//
//  Created by Mehmet ÖKSÜZ on 22.04.2024.
//

import Foundation

class FavoriteManager {
    
    static let shared = FavoriteManager()
    private init() {}
    
    let userDefaults = UserDefaults.standard
    let key = "favorites"
    var items: [Article] = []
    
    func load() {
        
        if let data = userDefaults.object(forKey: key) as? Data,
           let favorite = try? JSONDecoder().decode([Article].self, from: data) {
            self.items = favorite
            
        }
    }
    
    func get() -> [Article] {
        self.load()
        return items
    }
    
    func add(item: Article) {
        if let index = items.firstIndex(where: {$0.url == item.url}) {
            items.remove(at: index)
        } else {
            items.insert(item, at: 0)
        }
        save()
        sendNotification()
    }
    
    func delete(item: Article) {
        if let index = items.firstIndex(where: { $0.url == item.url}) {
            items.remove(at: index)
        } else {
            print("error")
        }
        save()
        sendNotification()
    }
    
    func isFavorite(item: Article) -> Bool {
        return items.contains {$0.url == item.url}
    }
    
    func save() {
        if let data = try? JSONEncoder().encode(items) {
            userDefaults.set(data, forKey: key)
        }
    }
    
    func sendNotification() {
        NotificationCenter.default.post(name: NSNotification.Name("notifications"), object: nil)
        
    }
}
