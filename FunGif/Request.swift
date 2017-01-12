//
//  Request.swift
//  FunGif
//
//  Created by Marshall Yang on 2016/12/21.
//  Copyright © 2016年 Marshall Yang. All rights reserved.
//

import Foundation
import Alamofire

protocol Request {
    
    var path: String { get }
    var params: [String: Any] { get }
    var method: HTTPMethod { get }
    
    associatedtype Response: Decodable
}
