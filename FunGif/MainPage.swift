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

class MainPage: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    // ----
    var category: String = ""
    var items: Array<Gif>!
    
    var configuration: configurationBlock?
    var dataSoucre: CustomDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        var path: String = ""
        if category.isEmpty {
            path = "trending"
        } else {
            path = category.replacingOccurrences(of: " ", with: "")
        }
        
        HUD.show(.labeledProgress(title: "Loading", subtitle: "..."), onView: view)
        
        let request = GifRequest(path: path, params: ["api_key": "dc6zaTOxFJmzC", "limit": 100], method: .get)
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
