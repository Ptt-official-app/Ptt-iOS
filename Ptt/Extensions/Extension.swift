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
        layer.backgroundColor = PttColors.tuna.color.cgColor
        layer.frame = CGRect(x: 0.0, y: self.frame.size.height - 1.0, width: self.frame.size.width, height: 1.0)
        self.clipsToBounds = true
        self.layer.addSublayer(layer)
        self.setNeedsDisplay()
    }
}

extension UILabel {
    func setBottomBorder() {
        let layer = CALayer()
        layer.backgroundColor = PttColors.tuna.color.cgColor
        layer.frame = CGRect(x: 0.0, y: self.frame.size.height - 1.0, width: self.frame.size.width, height: 1.0)
        self.clipsToBounds = true
        self.layer.addSublayer(layer)
        self.setNeedsDisplay()
    }
}

// Cache Formatters for Efficiency.
// See: https://sarunw.com/posts/how-expensive-is-dateformatter/
// https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/DataFormatting/Articles/dfDateFormatting10_4.html#//apple_ref/doc/uid/TP40002369-SW10
extension Date {

    private static let articleDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM dd HH:mm:ss yyyy"
        return formatter
    }()

    private static let boardDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd"
        return formatter
    }()

    func toArticleDateString() -> String {
        return Date.articleDateFormatter.string(from: self)
    }

    func toBoardDateString() -> String {
        return Date.boardDateFormatter.string(from: self)
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
