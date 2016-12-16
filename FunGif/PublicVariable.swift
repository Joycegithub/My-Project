//
//  PublicVariable.swift
//  FunGif
//
//  Created by Marshall Yang on 2016/12/11.
//  Copyright © 2016年 Marshall Yang. All rights reserved.
//

import UIKit

let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
let appDelegate = UIApplication.shared.delegate as? AppDelegate

typealias configurationBlock = (_ cell: UICollectionViewCell, _ item: AnyObject, _ indexPath: IndexPath) -> Void
