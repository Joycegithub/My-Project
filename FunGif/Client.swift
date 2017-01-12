//
//  Client.swift
//  FunGif
//
//  Created by Marshall Yang on 2016/12/21.
//  Copyright © 2016年 Marshall Yang. All rights reserved.
//

import Foundation

protocol Client {
    
    var host: String { get }
    
    func sendRequest<T: Request>(_ r: T, completionHandler: @escaping ([T.Response?], NSError?) -> Void)
}
