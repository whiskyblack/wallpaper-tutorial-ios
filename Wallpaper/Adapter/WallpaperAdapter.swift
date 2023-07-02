//
//  WallpaperAdapter.swift
//  Wallpaper
//
//  Created by TrungNV (Macbook) on 28/06/2023.
//

import UIKit

class WallpaperAdapter: NSObject {
    var data = [WallpaperModel]()
    private var layoutOption: WallpaperViewType = .small
    
    func setLayoutOption(layout:WallpaperViewType){
        self.layoutOption =  layout
    }
}

extension WallpaperAdapter: UICollectionViewDelegate{
//    
}

extension WallpaperAdapter: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        var height:CGFloat = 91
        var heightRatio:CGFloat = 1
        let itemSpacing = self.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: indexPath.section)
        var width = screenWidth
        var numberOfItems:CGFloat = 1
        switch layoutOption{
        case .big:
            numberOfItems = 1
            heightRatio = 1
            width = screenWidth
        case .small:
            numberOfItems = 3
            heightRatio = 2
            width = (width - (numberOfItems-1)*itemSpacing)/numberOfItems
        }
        height = heightRatio * width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if(layoutOption == .small){
            return 4
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
}

extension WallpaperAdapter: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = data[indexPath.item]
        switch layoutOption{
        case .small:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IMGSmallCell", for: indexPath) as! IMGSmallCell
            cell.loadImage(urlImage: model.imageUrl)
            return cell
        case .big:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IMGBigCell", for: indexPath) as! IMGBigCell
            cell.loadImage(urlImage: model.imageUrl)
            return cell
        }
    }
}
