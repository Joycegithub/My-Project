//
//  GifRequest.swift
//  FunGif
//
//  Created by Marshall Yang on 2016/12/21.
//  Copyright © 2016年 Marshall Yang. All rights reserved.
//

import Foundation
import Alamofire

struct GifRequest: Request {
    
    var path: String = ""
    var params: [String : Any] = [:]
    var method: HTTPMethod = .get
    
    typealias Response = Gif
    
}
