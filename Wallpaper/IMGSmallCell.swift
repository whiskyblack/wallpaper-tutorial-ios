//
//  IMGSmallCell.swift
//  Wallpaper
//
//  Created by TrungNV (Macbook) on 28/06/2023.
//

import UIKit
import Kingfisher

class IMGSmallCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func loadImage(urlImage:String){
        imageView.load(_url: urlImage)
    }
    
}

extension UIImageView{
    func load(_url:String){
        let url = URL(string: _url)
        self.kf.setImage(with: url)
    }
}
