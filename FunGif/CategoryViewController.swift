
//
//  ViewController.swift
//  FunGif
//
//  Created by Marshall Yang on 2016/12/11.
//  Copyright © 2016年 Marshall Yang. All rights reserved.
//

import UIKit
import Kingfisher

class CategoryViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var sliderView: CustomSliderView?

    var textStrs = ["Beauty", "Justin Bieber", "Michael Jordan", "Jekky", "West World"]
    
    let path = Bundle.main.path(forResource: "Categories", ofType: "plist")
    var datas: Array<Dictionary<String, AnyObject>> {
        return NSArray(contentsOfFile: path!) as! Array<Dictionary<String, AnyObject>>
    }
    
    var customDataSource: CustomDataSource!
    
    var selectedIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "Categories"
        
        configureDataSource()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureDataSource() {
        let configuration: configurationBlock = { [unowned self] cell, item, indexPath in
            
            let imageView = cell.viewWithTag(1) as! MyImageView
            imageView.tapTag = indexPath.row
            
            let category = self.datas[indexPath.row]
            let name = category["Category_Example_Gif_Name"] as! String
            let path = Bundle.main.path(forResource: name, ofType: "gif")!
            let url = URL(fileURLWithPath: path)
            
            imageView.kf.setImage(with: url)
            
            let label = cell.viewWithTag(2) as! UILabel
            label.text = category["Category_Name"] as? String
            
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(CategoryViewController.handlerLongPress(_:)))
            
            let coverLayer = cell.viewWithTag(3)
            coverLayer!.addGestureRecognizer(longPress)
        }
        customDataSource = CustomDataSource(aItems: datas as Array<AnyObject>, aIdentifier: "Cell", aConfiguration: configuration)
        collectionView.dataSource = customDataSource
    }
    
    
    // MARK: - Click to Toggle Slide Menu
    
    @IBAction func menuClicked(_ sender: UIBarButtonItem) {
        if let appDelegate = appDelegate {
            appDelegate.toggleLeftMenu(sender, animated: true)
        }
    }
    
    @IBAction func question(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "提示", message: "长按分类可以打开细分类界面", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Dismiss Slider View
    
    func dismissSliderView() {
        if let sliderView = sliderView {
            UIView.animate(withDuration: 0.3, animations: {
                sliderView.center.x += self.view.bounds.width
            }, completion: { (_) in
                sliderView.removeFromSuperview()
            })
        }
    }
    
    // MARK: - Handler Long Press Method
    
    func handlerLongPress(_ sender: UILongPressGestureRecognizer) {
        
        var row = 0
        
        var rect: CGRect = .zero
        var cell: UIView?
        
        if let coverLayer = sender.view {
            if let cellView = coverLayer.superview {
                 cell = cellView
                rect = cellView.convert(cellView.frame, to: self.view)
                let imageView = cellView.viewWithTag(1) as! MyImageView
                selectedIndex = IndexPath(row: imageView.tapTag, section: 0)
                row = imageView.tapTag
            }
            
        }
        
        let location = sender.location(in: self.view)
        
        if sender.state == .began {
            print("begin")
            if cell != nil {
                let cover = cell?.viewWithTag(99)
                cover?.alpha = 0.6
            }
            
            // -----
            
            dismissSliderView()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1*0.5, execute: { [unowned self] in
                let dis = location.y - self.view.bounds.height
                
                let pointToTop = abs(dis) < rect.height ? false : true
                var sliderRect: CGRect = .zero
                
                if pointToTop {
                    sliderRect = CGRect(x: self.view.bounds.width * 1.5, y: rect.origin.y + rect.height, width: self.view.bounds.width, height: 20)
                } else {
                    sliderRect = CGRect(x: self.view.bounds.width * 1.5, y: rect.origin.y - 50, width: self.view.bounds.width, height: 20)
                }
                
                let category = self.datas[row]
                let labels = category["Subcategories"] as! Array<String>
                
                self.sliderView = CustomSliderView(frame: sliderRect, labels: labels, pointToTop: pointToTop, targetFrame: rect)
                self.sliderView?.delegate = self
                
                self.view.addSubview(self.sliderView!)
                self.collectionView.isScrollEnabled = false
                UIView.animate(withDuration: 0.2, animations: {
                    self.sliderView!.center.x = self.view.center.x
                }, completion: { _ in
                    self.collectionView.isScrollEnabled = true
                })
            })

        }
        
        if sender.state == .ended {
            print("end")
            if cell != nil {
                let cover = cell?.viewWithTag(99)
                cover?.alpha = 0.0
            }
            
            // -----
            
        }
        
        if sender.state == .recognized {
            print("recognized")
            return
        }
        
        if sender.state == .changed {
            print("changed")
            return
        }
        
        if sender.state == .possible {
            print("possible")
            return
        }
        
        
    }
}

// MARK: - Extensing UICollectionViewDelegate

extension CategoryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Select \(indexPath.row) \(self.datas[indexPath.row]["Category_Name"])")
        
        let mainNaviVC = storyboard?.instantiateViewController(withIdentifier: "MainPageNavi") as! UINavigationController
        if let mainpage = mainNaviVC.viewControllers.first as? MainPage {
            mainpage.category = self.datas[indexPath.row]["Category_Name"] as! String
        }
        if let appDelegate = appDelegate {
            
            appDelegate.centerViewController = mainNaviVC
        }

    }
}


// MARK: - Extensing UICollectionViewFlowLayout

extension CategoryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = UIScreen.main.bounds.width / 2 - 5
        let height = width * 0.7
        return CGSize(width: width, height: height)
    }
}

// MARK: - Extensing UIScrollView Delegate

extension CategoryViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        dismissSliderView()
    }
}


// MARK: Class Define MyImageView For tapTag Property
open class MyImageView: UIImageView {
    var tapTag: Int = 0
}

// MARK: Extension for CustomSliderView

extension CategoryViewController: CustomSliderViewProtocol {
    func didPressButton(sender: UIButton) {
        
        print("taptag: \(selectedIndex?.row)! tag: \(sender.tag)")
        dismissSliderView()
        
        let mainNaviVC = storyboard?.instantiateViewController(withIdentifier: "MainPageNavi") as! UINavigationController
        if let mainpage = mainNaviVC.viewControllers.first as? MainPage {
            let category = self.datas[selectedIndex!.row]
            let subcategories = category["Subcategories"] as! Array<String>
            mainpage.category = subcategories[sender.tag-1];
        }
        if let appDelegate = appDelegate {
            appDelegate.centerViewController = mainNaviVC
        }
    }
}
