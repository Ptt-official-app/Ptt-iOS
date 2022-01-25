//
//  Extension.swift
//  Ptt
//
//  Created by denkeni on 2020/3/27.
//  Copyright © 2020 Ptt. All rights reserved.
//

import UIKit

extension UIView {

    func ptt_add(subviews: [UIView]) {
        for subview in subviews {
            subview.translatesAutoresizingMaskIntoConstraints = false
            addSubview(subview)
        }
    }
}

extension UITableViewCell {
    static func cellIdentifier() -> String {
        return String(describing: self)
    }
}

extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}

extension UITextField {
    func setBottomBorder() {
        let layer = CALayer()
        layer.backgroundColor = UIColor(red:56/255, green:56/255, blue:61/255, alpha:1.0).cgColor
        layer.frame = CGRect(x: 0.0, y: self.frame.size.height - 1.0, width: self.frame.size.width, height: 1.0)
        self.clipsToBounds = true
        self.layer.addSublayer(layer)
        self.setNeedsDisplay()
    }
}

extension UILabel {
    func setBottomBorder() {
        let layer = CALayer()
        layer.backgroundColor = UIColor(red:56/255, green:56/255, blue:61/255, alpha:1.0).cgColor
        layer.frame = CGRect(x: 0.0, y: self.frame.size.height - 1.0, width: self.frame.size.width, height: 1.0)
        self.clipsToBounds = true
        self.layer.addSublayer(layer)
        self.setNeedsDisplay()
    }
}

extension Date {
    func toDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss yyyy" //Specify your format that you want
        return dateFormatter.string(from: self as Date)
    }
}

extension UIImage {
    class func backgroundImg(from color: UIColor) -> UIImage? {
        let size: CGSize = CGSize(width: 1, height: 1)
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
