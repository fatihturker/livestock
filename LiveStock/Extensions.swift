//
//  Extensions.swift
//  LiveStock
//
//  Created by FATİH TÜRKER on 11/06/16.
//  Copyright © 2016 FATİH TÜRKER. All rights reserved.
//

import Foundation
import ObjectiveC
extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func removeObject(object: Element) {
        if let index = indexOf(object) {
            removeAtIndex(index)
        }
    }
}

extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func appendObjectIfNotExists(object: Element) {
        if !contains(object) {
            append(object)
        }
    }
}

var AssociatedHandeledDatePicker: UInt8 = 0
var AssociatedHandeledTextField: UInt8 = 0
extension UIButton {
    var HandeledDatePicker:UIDatePicker! {
        get {
            return objc_getAssociatedObject(self, &AssociatedHandeledDatePicker) as! UIDatePicker
        }
        set {
            objc_setAssociatedObject(self, &AssociatedHandeledDatePicker, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var HandeledTextField:UITextField! {
        get {
            return objc_getAssociatedObject(self, &AssociatedHandeledTextField) as! UITextField
        }
        set {
            objc_setAssociatedObject(self, &AssociatedHandeledTextField, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}