//
//  MyCollectionViewCell.swift
//  MyWeather
//
//  Created by Yiğit Karakurt on 30.12.2022.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var cityLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.cornerRadius = contentView.bounds.width / 2
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 1

    }
    
    
}
