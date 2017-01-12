//
//  WaterFallWithInsetLayout.swift
//  SimulateMVVM
//
//  Created by Marshall Yang on 2016/12/5.
//  Copyright © 2016年 Marshall Yang. All rights reserved.
//

import UIKit

protocol WaterFallLayoutDelegate {
    func waterfallLayoutItem(for width: CGFloat, at indexPath: IndexPath) -> CGFloat
}

class WaterFallLayout: UICollectionViewLayout {
    
    var columnMargin: CGFloat!
    var rowMargin: CGFloat!
    var insets: UIEdgeInsets!
    var count: Int!
    var cellInfo: NSMutableDictionary!
    var delegate: WaterFallLayoutDelegate?
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func prepare() {
        super.prepare()
        self.columnMargin = 1
        self.rowMargin = 1
        self.insets = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        self.count = 2
        self.cellInfo = NSMutableDictionary()

        for i in 0..<self.count {
            let index = String(format: "%d", i)
            self.cellInfo[index] = self.insets.top
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        self.cellInfo.enumerateKeysAndObjects({ [unowned self] (columnIndex, minY, stop) in
            self.cellInfo[columnIndex as! String] = self.insets.top
        })
        
        var array = Array<UICollectionViewLayoutAttributes>()
        
        let count = self.collectionView!.numberOfItems(inSection: 0)
        
        for i in 0..<count {
            let attrs = self.layoutAttributesForItem(at: IndexPath(item: i, section: 0))
            array.append(attrs!)
        }
    
        return array
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        var minYForColumn = "0"
        self.cellInfo.enumerateKeysAndObjects({ [unowned self] (columnIndex, minY, stop) in
            if ((minY as! CGFloat) < (self.cellInfo[minYForColumn] as! CGFloat)) {
                minYForColumn = columnIndex as! String
            }
        })
        
        let width = (self.collectionView!.frame.size.width - self.insets.left - self.insets.right - self.columnMargin * CGFloat((self.count - 1))) / CGFloat(self.count)
        let height = self.delegate!.waterfallLayoutItem(for: width, at: indexPath)
        let x = self.insets.left + (width + self.columnMargin) * CGFloat((minYForColumn as NSString).floatValue)
        let y = self.rowMargin + (self.cellInfo[minYForColumn] as! CGFloat)
        
        self.cellInfo[minYForColumn] = y + height
        
        let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attrs.frame = CGRect(x: x, y: y, width: width, height: height)
        return attrs
    }
    
    override var collectionViewContentSize: CGSize {
        let width = self.collectionView!.frame.size.width
        
        var maxY: CGFloat = 0
        
        self.cellInfo.enumerateKeysAndObjects({ (columnIndex, itemMaxY, stop) in
            if (itemMaxY as! CGFloat) > maxY {
                maxY = (itemMaxY as! CGFloat)
            }
        })
        
        return CGSize(width: width, height: maxY + self.insets.bottom)
    }
    
    
}
