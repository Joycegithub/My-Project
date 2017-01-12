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
        
        guard let fixed_height_downsampled = images["fixed_height_downsampled"] as? [String: Any] else {
            return nil
        }
        
        guard let urlStr = fixed_height_downsampled["url"] as? String,
                let widthStr = fixed_height_downsampled["width"] as? String,
                let heightStr = fixed_height_downsampled["height"] as? String
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
