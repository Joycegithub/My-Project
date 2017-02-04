//
//  Gif.swift
//  FunGif
//
//  Created by Marshall Yang on 2016/12/21.
//  Copyright © 2016年 Marshall Yang. All rights reserved.
//

import UIKit

struct Gif {
    
    var id: String
    var gifUrl: URL?
    var gifSize: CGSize
    
    init?(dic: [String: Any]) {
        
        guard let id = dic["id"] as? String else {
            return nil
        }
        
        guard let images = dic["images"] as? [String: Any] else {
            return nil
        }
        
        guard let image = images[userChoice as! String] as? [String: Any] else {
            return nil
        }
        
        guard let urlStr = image["url"] as? String,
                let widthStr = image["width"] as? String,
                let heightStr = image["height"] as? String
            else {
            return nil
        }
        
        let url = URL(string: urlStr)
        let width = (widthStr as NSString).floatValue
        let height = (heightStr as NSString).floatValue
        
        self.id = id
        self.gifUrl = url
        self.gifSize = CGSize(width: CGFloat(width), height: CGFloat(height))
    }
}

extension Gif: Decodable {
    static func parse(dic: [String : Any]) -> Gif? {
        return Gif(dic: dic)
    }
}
