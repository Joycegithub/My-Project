//
//  MenuTableViewController.swift
//  FunGif
//
//  Created by Marshall Yang on 2016/12/11.
//  Copyright © 2016年 Marshall Yang. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

    private let menuStrs = ["Search", "Trending", "Categories", "Marked", "Upload", "Setting"]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let indexPath = IndexPath(row: 2, section: 0)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, retu	rn the number of rows
        return menuStrs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        cell.label.text = menuStrs[indexPath.row]
        
        var image: UIImage!
        
        switch indexPath.row {
        case 0:
            image = UIImage(named: "search")
        case 1:
            image = UIImage(named: "trending-up")
        case 2:
            image = UIImage(named: "category")
        case 3:
            image = UIImage(named: "favorite")
        case 4:
            image = UIImage(named: "upload")
        default:
            image = UIImage(named: "setting")
        }
        
        cell.iconImageView.image = image
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 64
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 64))
            header.backgroundColor = UIColor.black
            return header
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
        } else if indexPath.row == 1 {
            let mainNaviVC = storyboard?.instantiateViewController(withIdentifier: "MainPageNavi") as! UINavigationController
            if let appDelegate = appDelegate {
                appDelegate.centerViewController = mainNaviVC
            }
        } else if indexPath.row == 2 {
            let categoryNaviVC = storyboard?.instantiateViewController(withIdentifier: "CategoryNavi") as! UINavigationController
            if let appDelegate = appDelegate {
                appDelegate.centerViewController = categoryNaviVC
            }
            return
        } else if indexPath.row == 3 {
            
        } else if indexPath.row == 4 {
            
        } else {
            
        }
    }
    
//    func prepareVC(_ row: Int) -> UIViewController? {
//        var identifier = ""
//        switch row {
//        case 0:
//            identifier = "SearchNavi"
//        case 1:
//            identifier = "MainPageNavi"
//        case 2:
//            identifier = "CategoryNavi"
//        case 3:
//            identifier = ""
//        default:
//            identifier = ""
//        }
//        
//        return storyboard?.instantiateViewController(withIdentifier: identifier)
//    }
}
