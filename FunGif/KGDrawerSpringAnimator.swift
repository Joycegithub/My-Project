//
//  KGDrawerAnimator.swift
//  KGDrawerViewController
//
//  Created by Kyle Goddard on 2015-02-10.
//  Copyright (c) 2015 Kyle Goddard. All rights reserved.
//

import UIKit

open class KGDrawerSpringAnimator: NSObject {
    
    let kKGCenterViewDestinationScale:CGFloat = 0.7
    
    open var animationDelay: TimeInterval        = 0.0
    open var animationDuration: TimeInterval     = 0.5
    open var initialSpringVelocity: CGFloat        = 0.0 // 9.1 m/s == earth gravity accel.
    open var springDamping: CGFloat                = 5.0
    
    // TODO: can swift have private functions in a protocol?
    fileprivate func applyTransforms(_ side: KGDrawerSide, drawerView: UIView, centerView: UIView) {
        
        let direction = side.rawValue
        let sideWidth = drawerView.bounds.width
        let centerWidth = centerView.bounds.width
        let centerHorizontalOffset = direction * sideWidth
        let scaledCenterViewHorizontalOffset = direction * (sideWidth - (centerWidth - kKGCenterViewDestinationScale * centerWidth) / 2.0)
        
        let sideTransform = CGAffineTransform(translationX: centerHorizontalOffset, y: 0.0)
        drawerView.transform = sideTransform
        
        let centerTranslate = CGAffineTransform(translationX: scaledCenterViewHorizontalOffset, y: 0.0)
        //let centerScale = CGAffineTransform(scaleX: kKGCenterViewDestinationScale, y: kKGCenterViewDestinationScale)
        //centerView.transform = centerScale.concatenating(centerTranslate)
        centerView.transform = centerTranslate
    }
    
    fileprivate func resetTransforms(_ views: [UIView]) {
        for view in views {
            view.transform = CGAffineTransform.identity
        }
    }

}

extension KGDrawerSpringAnimator: KGDrawerAnimating {
    
    public func openDrawer(_ side: KGDrawerSide, drawerView: UIView, centerView: UIView, animated: Bool, complete:  @escaping (Bool) -> Void) {
        /*
        if (animated) {
            UIView.animate(withDuration: animationDuration,
                delay: animationDelay,
                usingSpringWithDamping: springDamping,
                initialSpringVelocity: initialSpringVelocity,
                options: UIViewAnimationOptions.curveLinear,
                animations: {
                    self.applyTransforms(side, drawerView: drawerView, centerView: centerView)
                    
                }, completion: complete)
        } else {
            self.applyTransforms(side, drawerView: drawerView, centerView: centerView)
        }
        */
        if (animated) {
            UIView.animate(withDuration: animationDuration, animations: { 
                self.applyTransforms(side, drawerView: drawerView, centerView: centerView)
            }, completion: complete)
        } else {
            self.applyTransforms(side, drawerView: drawerView, centerView: centerView)
        }
    }
    
    public func dismissDrawer(_ side: KGDrawerSide, drawerView: UIView, centerView: UIView, animated: Bool, complete: @escaping (Bool) -> Void) {
        /*
        if (animated) {
            UIView.animate(withDuration: animationDuration,
                delay: animationDelay,
                usingSpringWithDamping: springDamping,
                initialSpringVelocity: initialSpringVelocity,
                options: UIViewAnimationOptions.curveLinear,
                animations: {
                    self.resetTransforms([drawerView, centerView])
            }, completion: complete)
        } else {
            self.resetTransforms([drawerView, centerView])
        }
        */
        if (animated) {
            UIView.animate(withDuration: animationDuration, animations: { 
                self.resetTransforms([drawerView, centerView])
            }, completion: complete)
        } else {
            self.resetTransforms([drawerView, centerView])
        }
    }
    
    public func willRotateWithDrawerOpen(_ side: KGDrawerSide, drawerView: UIView, centerView: UIView) {
        
    }
    
    public func didRotateWithDrawerOpen(_ side: KGDrawerSide, drawerView: UIView, centerView: UIView) {
        UIView.animate(withDuration: animationDuration,
            delay: animationDelay,
            usingSpringWithDamping: springDamping,
            initialSpringVelocity: initialSpringVelocity,
            options: UIViewAnimationOptions.curveLinear,
            animations: {}, completion: nil )
    }
    
}
