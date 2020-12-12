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
    
    private class func viewInNibNamed<T: UIView>(_ nibNamed: String) -> T {
      return Bundle.main.loadNibNamed(nibNamed, owner: nil, options: nil)!.first as! T
    }
    
    class func nib() -> Self {
      return viewInNibNamed(nameOfClass)
    }
    
    class func nib(_ frame: CGRect) -> Self {
      let view = nib()
      view.frame = frame
      view.layoutIfNeeded()
      return view
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
