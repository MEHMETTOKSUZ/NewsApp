//
//  SearchTableViewCell.swift
//  NewsApp
//
//  Created by Mehmet ÖKSÜZ on 16.04.2024.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func itemFromCell(item: HomeCollectionViewCell.ViewModel) {
        
        if let image = item.urlToImage {
            self.newsImageView.downloaded(from: image, contentMode: .scaleToFill)
        }
        self.newsTitleLabel.text = item.title
    }
}
