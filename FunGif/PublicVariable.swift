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

let user_choice_size = "size"
let normal_size = "fixed_height_downsampled"
let compress_size = "fixed_height_small"

let userChoice = UserDefaults.standard.object(forKey: user_choice_size)
