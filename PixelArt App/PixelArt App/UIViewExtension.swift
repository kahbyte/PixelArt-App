//
//  UIViewExtension.swift
//  PixelArt App
//
//  Created by Kauê Sales on 10/11/20.
//

import UIKit

extension UIView {
    func copyView<T: UIView>() -> T {
            return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! T
        }
}
