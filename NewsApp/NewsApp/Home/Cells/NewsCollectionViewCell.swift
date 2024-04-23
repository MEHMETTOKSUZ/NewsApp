//
//  NewsCollectionViewCell.swift
//  NewsApp
//
//  Created by Mehmet ÖKSÜZ on 14.04.2024.
//

import UIKit

class NewsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var newsTimeLabel: UILabel!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var favoriteButtonClicked: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func itemFromCell(item: HomeCollectionViewCell.ViewModel) {
        
        if let image = item.urlToImage {
            self.newsImageView.downloaded(from: image, contentMode: .scaleToFill)
        }
        self.newsTitleLabel.text = item.title
        self.newsTimeLabel.text = item.formattedPublishedAt
        let imageName : String = item.isFavorite ? "bookmark.fill": "bookmark"
        self.favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        
    }
    
    @IBAction func favoriteButtonClicked(_ sender: Any) {
        self.favoriteButtonClicked?()
    }
}
