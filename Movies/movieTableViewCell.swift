//
//  movieTableViewCell.swift
//  Movies
//
//  Created by huy ngo on 11/10/15.
//  Copyright © 2015 huy ngo. All rights reserved.
//

import UIKit

class movieTableViewCell: UITableViewCell, UICollectionViewDelegate {
    var collectionView: UICollectionView!
    
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var star1Image: UIImageView!
    @IBOutlet var Star2Image: UIImageView!
    @IBOutlet var star3Image: UIImageView!
    @IBOutlet var star4image: UIImageView!
    @IBOutlet var star5image: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
