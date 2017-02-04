//
//  SettingViewController.swift
//  FunGif
//
//  Created by Marshall Yang on 2017/2/4.
//  Copyright © 2017年 Marshall Yang. All rights reserved.
//

import UIKit
import Kingfisher
import PKHUD

class SettingViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        let label = UILabel(frame: footer.bounds)
        label.font = UIFont(name: "AmericanTypewriter", size: 20)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "功能正在完善中..."
        footer.addSubview(label)
        
        tableView.tableFooterView = footer
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "缓存"
        }
        return ""
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CacheCell")
            let button = cell?.viewWithTag(1) as! UIButton
            button.addTarget(self, action: #selector(SettingViewController.clearButtonClicked(_:)), for: .touchUpInside)
            return cell!
        }
        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 30))
            let cacheLabel = UILabel(frame: header.bounds)
            cacheLabel.font = UIFont(name: "AmericanTypewriter", size: 15)
            cacheLabel.textColor = UIColor.white
            cacheLabel.textAlignment = .center
            cacheLabel.text = "缓存管理"
            ImageCache.default.calculateDiskCacheSize(completion: { (asize) in
                cacheLabel.text = "缓存管理, 已经占用: \(asize / 1024 / 1024)MB"
            })
            header.addSubview(cacheLabel)
            return header
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    @IBAction func menuClicked(_ sender: UIBarButtonItem) {
        if let appDelegate = appDelegate {
            appDelegate.toggleLeftMenu(sender, animated: true)
        }
    }
    
    func clearButtonClicked(_ sender: UIButton) {
        let alert = UIAlertController(title: "清理缓存", message: "是否清理缓存", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .default) { (_) in
            ImageCache.default.clearDiskCache(completion: { 
                HUD.show(.labeledSuccess(title: "清理完成", subtitle: ""))
                HUD.hide(afterDelay: 2, completion: { (_) in
                    self.tableView.reloadData()
                })
            })
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
