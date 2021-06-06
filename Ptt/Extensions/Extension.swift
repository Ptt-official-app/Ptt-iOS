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

struct Utility {

    static func isPttArticle(url: URL) -> Bool {
        if url.host == "www.ptt.cc" {
            let substrings = url.path.split(separator: "/")
            if substrings.count == 3 &&
                substrings[0] == "bbs" &&
                substrings[2].contains(".html") &&
                !substrings[2].contains("index") {
                return true
            }
        }
        return false
    }

    /// Get boardName and filename from PTT url
    /// - Parameter path: path of the url
    static func info(from path: String) -> (boardName: String?, filename: String?) {
        var boardName : String? = nil
        var filename : String? = nil
        let substrings = path.split(separator: "/")
        if substrings.count == 3 {
            boardName = String(substrings[1])
            let fullFilename = String(substrings[2])
            if fullFilename.contains(".html") {
                let _filename = fullFilename.replacingOccurrences(of: ".html", with: "")
                filename = _filename
            }
        }
        return (boardName, filename)
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

extension UIBarButtonItem {
    static func menuButton(_ target: Any?, action: Selector, imageName: String) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFit
        
//        button.setImage(UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal), for: .normal)
//        button.setImage(UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate), for: .highlighted)

        let menuBarItem = UIBarButtonItem(customView: button)
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 49).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 76).isActive = true
        return menuBarItem
    }
}
