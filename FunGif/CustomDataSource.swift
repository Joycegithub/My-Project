//
//  CustomDataSource.swift
//  FunGif
//
//  Created by Marshall Yang on 2016/12/12.
//  Copyright © 2016年 Marshall Yang. All rights reserved.
//

import UIKit

class CustomDataSource: NSObject, UICollectionViewDataSource {

    var items: Array<AnyObject>
    var identifier: String
    var configuration: configurationBlock
    
    init(aItems: Array<AnyObject>, aIdentifier: String, aConfiguration: @escaping configurationBlock) {
        self.items = aItems
        self.identifier = aIdentifier
        self.configuration = aConfiguration
        super.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        
        let item = items[indexPath.row]
        configuration(cell, item, indexPath)
        
        return cell
    }
}
