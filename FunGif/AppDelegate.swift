//
//  AppDelegate.swift
//  FunGif
//
//  Created by Marshall Yang on 2016/10/7.
//  Copyright © 2016年 Marshall Yang. All rights reserved.
//

import UIKit
import Kingfisher
import PKHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WXApiDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = prepareDrawer()
        window!.makeKeyAndVisible()
        
        KingfisherManager.shared.cache.pathExtension = "gif"
        
        WXApi.registerApp("wxa8a702e72afa19e2")
        
        if (userChoice == nil) {
            UserDefaults.standard.set(normal_size, forKey: user_choice_size)
        }
        
        print(userChoice)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return WXApi.handleOpen(url, delegate: self)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return WXApi.handleOpen(url, delegate: self)
    }
    
    func onReq(_ req: BaseReq!) {
        //onReq是微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面。
    }
    func onResp(_ resp: BaseResp!) {
        //如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面。
        HUD.show(.labeledSuccess(title: "分享成功", subtitle: ""))
        HUD.hide(afterDelay: 1)
    }

    var drawerVC: KGDrawerViewController!
    // MARK: - KGFloatingDrawer
    func prepareDrawer() -> KGDrawerViewController {
        if drawerVC == nil {
            drawerVC = KGDrawerViewController()
        }
        
        drawerVC.centerViewController = centerViewController
        
        let leftMenuVC = storyboard.instantiateViewController(withIdentifier: "MenuVC") as! MenuTableViewController
        drawerVC.leftViewController = leftMenuVC
        
        return drawerVC
    }
    
    fileprivate var _centerViewController: UIViewController?
    var centerViewController: UIViewController {
        get {
            if let viewController = _centerViewController {
                return viewController
            }
            return storyboard.instantiateViewController(withIdentifier: "CategoryNavi") as! UINavigationController
        }
        set {
            if let drawerViewController = drawerVC {
                drawerViewController.closeDrawer(drawerViewController.currentlyOpenedSide, animated: true) { finished in }
                if drawerViewController.centerViewController != newValue {
                    drawerViewController.centerViewController = newValue
                }
            }
            _centerViewController = newValue
        }
    }
    
    func toggleLeftMenu(_ sender:AnyObject, animated:Bool) {
        drawerVC.toggleDrawer(.left, animated: animated, complete: { _ in
            
        })
    }
}

