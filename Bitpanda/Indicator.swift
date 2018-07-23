//
//  Indicator.swift
//  Bitpanda
//
//  Created by Apurva Kochar on 7/23/18.
//  Copyright © 2018 Bitpanda. All rights reserved.
//

import UIKit

fileprivate var ActivityIndicatorViewAssociativeKey = "ActivityIndicatorViewAssociativeKey"

extension UIView {
    var activityIndicatorView: UIActivityIndicatorView {
        get {
            if let activityIndicatorView = objc_getAssociatedObject(self, &ActivityIndicatorViewAssociativeKey) as? UIActivityIndicatorView {
                return activityIndicatorView
            } else {
                let activityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                activityIndicatorView.activityIndicatorViewStyle = .gray
                activityIndicatorView.color = .gray
                activityIndicatorView.center = center
                activityIndicatorView.hidesWhenStopped = true
                addSubview(activityIndicatorView)
                
                objc_setAssociatedObject(self, &ActivityIndicatorViewAssociativeKey, activityIndicatorView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return activityIndicatorView
            }
        }
        
        set {
            addSubview(newValue)
            objc_setAssociatedObject(self, &ActivityIndicatorViewAssociativeKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
    }
}
