//
//  IMGBigCell.swift
//  Wallpaper
//
//  Created by TrungNV (Macbook) on 28/06/2023.
//

import UIKit

class IMGBigCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func loadImage(urlImage:String){
        imageView.load(_url: urlImage)
    }
    
}
