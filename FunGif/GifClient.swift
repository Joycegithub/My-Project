//
//  GifClient.swift
//  FunGif
//
//  Created by Marshall Yang on 2016/12/21.
//  Copyright © 2016年 Marshall Yang. All rights reserved.
//

import Foundation
import Alamofire

struct GifClient: Client {
    var host: String = "https://api.giphy.com/v1/gifs/"
    
    func sendRequest<T : Request>(_ r: T, completionHandler: @escaping ([T.Response?], NSError?) -> Void) {
        
        let url = host.appending(r.path)
        
        Alamofire.request(url, method: r.method, parameters: r.params, encoding: URLEncoding.default, headers: nil).validate().responseJSON { (responseJSON) in
            
            guard responseJSON.result.isSuccess else {
                DispatchQueue.main.async {
                    completionHandler([], NSError(domain: "Connection Error", code: 909, userInfo: nil))
                }
                return
            }
            
            guard let json = responseJSON.result.value as? [String: Any] else {
                DispatchQueue.main.async {
                    completionHandler([], NSError(domain: "Connection Error", code: 909, userInfo: nil))
                }
                return
            }
            
            guard let datas = json["data"] as? [[String: Any]] else {
                DispatchQueue.main.async {
                    completionHandler([], NSError(domain: "Connection Error", code: 909, userInfo: nil))
                }
                return
            }
            
            var res = [Any?]()
            for data in datas {
               res.append(T.Response.parse(dic: data) ?? nil)
            }
            
            DispatchQueue.main.async {
                completionHandler(res as! [T.Response?], nil)
            }
        }
    }
}
