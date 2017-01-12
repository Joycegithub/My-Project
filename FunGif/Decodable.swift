//
//  Decodable.swift
//  FunGif
//
//  Created by Marshall Yang on 2016/12/21.
//  Copyright © 2016年 Marshall Yang. All rights reserved.
//

import Foundation

protocol Decodable {
    static func parse(dic: [String: Any]) -> Self?
}
