//
//  WallpaperContentVCViewController.swift
//  Wallpaper
//
//  Created by TrungNV (Macbook) on 28/06/2023.
//

import UIKit
import Alamofire
import SwiftyJSON
import ESPullToRefresh

class WallpaperContentVCViewController: UIViewController {
    
    static let apiKey = "GxcJ7N0rjW-WRRB2D3XWhf3751S1OBBYtUbOG3IxKlY"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let adapter = WallpaperAdapter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionview()
        setupLoadMore()
        adapter.setLayoutOption(layout: WallpaperViewType.small)
        self.refresh()
        addButtonSearch()
    }


    private func setupCollectionview(){
        collectionView.register(UINib(nibName: "IMGSmallCell", bundle: nil), forCellWithReuseIdentifier: "IMGSmallCell")
        collectionView.register(UINib(nibName: "IMGBigCell", bundle: nil), forCellWithReuseIdentifier: "IMGBigCell")
        collectionView.delegate = adapter
        collectionView.dataSource = adapter
    }
    
    private func setupLoadMore(){
        let header = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
        let footer = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
        self.collectionView.es.addPullToRefresh(animator: header) {[weak self] in
            self?.refresh()
        }
        self.collectionView.es.addInfiniteScrolling(animator: header) {[weak self] in
            self?.loadMore()
        }
    }
    
    private func addButtonSearch(){
        let barButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(searchButtonTapped(_:)))
        barButtonItem.tintColor = .blue
        
        navigationItem.rightBarButtonItem = barButtonItem
        self.navigationController?.navigationBar.tintColor = .blue
    }
    
    @objc private func searchButtonTapped(_ sender:Any){
        showSearchViewController()
    }
    
    private func showSearchViewController(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let wallpaperId = "WallpaperPagerSearchVC"
        if let vc = storyboard.instantiateViewController(withIdentifier: wallpaperId) as? WallpaperPagerSearchVC{
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func refresh(){
        fetchAPI(isRefresh: false) {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.collectionView.es.stopPullToRefresh()
            }
        }
    }
    
    private func loadMore(){
        fetchAPI(isRefresh: false) {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.collectionView.es.stopLoadingMore()
            }
        }
    }
    
    private func fetchAPI(isRefresh:Bool, complete: @escaping ()->()){
        let searchURL = "https://ai.wallpapernew.net/search?text=vietnames"
                if let encoded = searchURL.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),let url = URL(string: encoded){
                    AF.request(url, method: .get).validate().responseData { response in
                        switch response.result {
                        case .success(let value):
                            let json = JSON(value)
                            var wallPapers: [WallpaperModel] = []
                            if let rawData = json["data"].to(type: WallpaperModel.self) {
                                wallPapers = rawData as! [WallpaperModel]
                                if(isRefresh){
                                    self.adapter.data = wallPapers
                                }else{
                                    self.adapter.data.append(contentsOf: wallPapers)
                                }
                                complete()
                            }
                        case .failure(let error):
                            print(error)
                            complete()
                        }
                    }
                }
    }
}
