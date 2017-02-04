//
//  MainPage.swift
//  FunGif
//
//  Created by Marshall Yang on 2016/12/19.
//  Copyright © 2016年 Marshall Yang. All rights reserved.
//

import UIKit
import Kingfisher
import PKHUD
import ESPullToRefresh

class MainPage: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    // ----
    var offset: Int = 1
    var currentOffset: Int = 1
    var limit: Int = 30
    
    var category: String = ""
    var items: Array<Gif>!
    
    var configuration: configurationBlock?
    var dataSoucre: CustomDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.es_addInfiniteScrolling { [weak self] in
            
            self!.currentOffset = self!.offset + 1
            
            var params: [String: Any] = [:]
            var path: String = ""
            
            if self!.category.isEmpty || self!.category == "All" {
                // Break load more
                self!.collectionView.es_noticeNoMoreData()
                self!.collectionView.es_stopLoadingMore()
            } else {
                path += "search"
                let q = self!.category.replacingOccurrences(of: " ", with: "+")
                print(q)
                params = ["api_key": "dc6zaTOxFJmzC", "limit": self!.limit, "q": q, "offset": self!.offset * self!.limit]
                
                let request = GifRequest(path: path, params: params, method: .get)
                GifClient().sendRequest(request, completionHandler: { (res, error) in
                    if error != nil {
                        print(error!)
                        self?.collectionView.es_noticeNoMoreData()
                        self?.collectionView.es_stopLoadingMore()
                        return
                    } else {
                        print("goes here")
                        if let gifs = res as? Array<Gif> {
                            print("goes here 2")
                            self!.items.append(contentsOf: gifs)
                            print(self!.items.count)
                            let left = self!.items.count - 1 - self!.limit
                            let right = self!.items.count - 1;
                            var indexPaths = [IndexPath]()
                            for i in left..<right {
                                indexPaths.append(IndexPath(row: i, section: 0))
                            }
                            
                            DispatchQueue.main.async {
                                self!.dataSoucre = CustomDataSource(aItems: self!.items as Array<AnyObject>, aIdentifier: "GifCell", aConfiguration: self!.configuration!)
                                self!.collectionView.dataSource = self?.dataSoucre!
                                self!.collectionView.reloadData()
                                self!.offset += 1
                                self!.collectionView.es_stopLoadingMore()
                            }
                            
                        }
                    }
                })
            }

        }
        
        preparePage()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func preparePage() {
        let layout = collectionView.collectionViewLayout as! WaterFallLayout
        layout.delegate = self
        
        var params: [String: Any] = [:]
        var path: String = ""
        
        if category.isEmpty || category == "All" {
            path = "trending"
            params = ["api_key": "dc6zaTOxFJmzC", "limit": limit]
        } else {
            path += "search"
            let q = category.replacingOccurrences(of: " ", with: "+")
            print(q)
            params = ["api_key": "dc6zaTOxFJmzC", "limit": limit, "q": q, "offset": offset]
        }
        
        print(path)
        self.navigationItem.title = category
        
        HUD.show(.labeledProgress(title: "Loading", subtitle: "Gifs are loading."), onView: view)
        
        let request = GifRequest(path: path, params: params, method: .get)
        GifClient().sendRequest(request) { (res, error) in
            if error != nil {
                print(error!)
                HUD.hide(animated: true)
                HUD.show(.error, onView: self.view)
                return
            }
            
            self.items = res as? Array<Gif>
            self.configuration = { (aCell, aItem, _) in
                if let cell = aCell as? GifCell, let item = aItem as? Gif {
                    cell.imageView.backgroundColor = UIColor.random()
                    cell.imageView.kf.setImage(with: item.gifUrl, placeholder: nil, options: [.transition(.fade(0.2))], progressBlock: nil, completionHandler: nil)
                }
            }
            self.dataSoucre = CustomDataSource(aItems: res as Array<AnyObject>, aIdentifier: "GifCell", aConfiguration: self.configuration!)
            self.collectionView.dataSource = self.dataSoucre
            self.collectionView.reloadData()
            HUD.hide(animated: true)
        }
    }

    // MARK: - Click to Toggle Slide Menu
    
    @IBAction func menuClicked(_ sender: UIBarButtonItem) {
        if let appDelegate = appDelegate {
            appDelegate.toggleLeftMenu(sender, animated: true)
        }
    }
    
}

extension MainPage: WaterFallLayoutDelegate {
    
    func waterfallLayoutItem(for width: CGFloat, at indexPath: IndexPath) -> CGFloat {
        if items.count == 0 {
            return 0
        }
        let item = items![indexPath.row]
        return item.gifSize.height / item.gifSize.width * width
    }
    
}

extension MainPage: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! GifCell
        if let image = cell.imageView.image {
            print("did select item at \(indexPath.row)")
            let key = self.items[indexPath.row].gifUrl!.absoluteString
            print(KingfisherManager.shared.cache.cachePath(forKey: key))
            let path = KingfisherManager.shared.cache.cachePath(forKey: key)
            
            let message = WXMediaMessage()
            message.setThumbImage(UIImage(contentsOfFile: path))
            let ext = WXEmoticonObject()
            ext.emoticonData = NSData(contentsOfFile: path) as Data!
            message.mediaObject = ext
            
            let req = SendMessageToWXReq()
            req.bText = false
            req.message = message
            
            let alertController = UIAlertController(title: "微信分享", message: "", preferredStyle: .actionSheet)
            let friendAction = UIAlertAction(title: "分享给朋友", style: .default, handler: { (_) in
                req.scene = Int32(WXSceneSession.rawValue)
                WXApi.send(req)
            })
            let cancelAction = UIAlertAction(title: "取消分享", style: .cancel, handler: { (_) in
                
            })
            
            alertController.addAction(friendAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        }
        
    }
}
