//
//  CustomSliderView.swift
//  FunGif
//
//  Created by Marshall Yang on 2016/12/12.
//  Copyright © 2016年 Marshall Yang. All rights reserved.
//

import UIKit

class CustomSliderView: UIView {
    
    var pointToTop: Bool
    var targetFrame: CGRect
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let context = UIGraphicsGetCurrentContext()
        if pointToTop {
            context?.move(to: CGPoint(x: targetFrame.midX - 10, y: rect.minY + 10))
            context?.addLine(to: CGPoint(x: targetFrame.midX, y: rect.minY))
            context?.addLine(to: CGPoint(x: targetFrame.midX + 10, y: rect.minY + 10))
            context?.addLine(to: CGPoint(x: targetFrame.midX - 10, y: rect.minY + 10))
        } else {
            context?.move(to: CGPoint(x: targetFrame.midX - 10, y: rect.maxY - 10))
            context?.addLine(to: CGPoint(x: targetFrame.midX, y: rect.maxY))
            context?.addLine(to: CGPoint(x: targetFrame.midX + 10, y: rect.maxY - 10))
            context?.addLine(to: CGPoint(x: targetFrame.midX - 10, y: rect.maxY - 10))
        }
        context?.setLineWidth(5)
        context?.setStrokeColor(UIColor.white.cgColor)
        context?.setFillColor(UIColor.white.cgColor)
        context?.fillPath()
        context?.strokePath()
    }
 
    var labels: Array<String> = []
    
    init(frame: CGRect, labels: Array<String>, pointToTop: Bool, targetFrame: CGRect) {
        self.labels = labels
        self.pointToTop = pointToTop
        self.targetFrame = targetFrame
        var height = frame.height
        if frame.height <= 40 {
            height = 40
        }
        height += 10
        super.init(frame: CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: height))

        self.backgroundColor = UIColor.clear
        self.alpha = 0.9
        
        self.setupButtons(pointToTop)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupButtons(_ isTop: Bool) {
        
        var rect = CGRect.zero
        let scrollView = UIScrollView()
        if pointToTop {
            rect = CGRect(x: 0, y: 10, width: bounds.width, height: bounds.height-10)
        } else {
            rect = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height-10)
        }
        scrollView.frame = rect
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = UIColor.white
        addSubview(scrollView)
        
        var width: CGFloat = 0
        
        for i in 0..<labels.count {
            
            let label = labels[i]
            
            let size = (label as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.init(name: "AmericanTypewriter", size: 15)!], context: nil).size
            width+=size.width
            
            let button = UIButton(type: .custom)
            button.setTitle(label, for: .normal)
            
            button.tag = i+1
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            
            if i == 0 {
                button.frame = CGRect(x: 5, y: scrollView.bounds.midY - size.height/2 - 2, width: size.width, height: size.height)
            } else {
                let pre = viewWithTag(i) as! UIButton
                button.frame = CGRect(x: pre.frame.maxX + 5, y: scrollView.bounds.midY - size.height/2 - 2, width: size.width, height: size.height)
            }
            
            button.setBackgroundImage(UIImage.imageWith(UIColor.random(), andSize: button.frame.size), for: .normal)
            button.sizeToFit()
            
            scrollView.addSubview(button)
        }
        
        scrollView.contentSize = CGSize(width: width + CGFloat(labels.count * 2) * 20, height: bounds.height-10)
    }
    
}

extension UIImage {
    class func imageWith(_ color: UIColor, andSize size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image!
    }
}

extension UIColor {
    class func random() -> UIColor {
        let r = CGFloat(CGFloat(arc4random() % 255) / 255.0)
        let g = CGFloat(CGFloat(arc4random() % 255) / 255.0)
        let b = CGFloat(CGFloat(arc4random() % 255) / 255.0)
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}
