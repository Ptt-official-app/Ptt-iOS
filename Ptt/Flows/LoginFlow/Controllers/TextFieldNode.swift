//
//  TextFieldNode.swift
//  Ptt
//
//  Created by You Gang Kuo on 2022/1/15.
//  Copyright © 2022 Ptt. All rights reserved.
//

import Foundation
import AsyncDisplayKit


enum TextFieldType {
    case Username, Password, Email
}

final class TextFieldNode : ASDisplayNode {

    var type: TextFieldType
    var textfield: UITextField
    var response:UILabel?
    
    var title: String? = nil {
        didSet {
            guard let title = title else { return }
            
            let attr:[NSAttributedString.Key : Any] = [
                NSAttributedString.Key.foregroundColor: PttColors.paleGrey.color,
                NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1)
            ]
            textfield.attributedPlaceholder = NSAttributedString.init(string: title, attributes:attr)
        }
    }

    init(type: TextFieldType) {
        textfield = UITextField()
        self.type = type
        super.init()
        response = self.responseLabel()
    

        
        switch type {
        case .Username:
            break
        case .Password:
            textfield.isSecureTextEntry = true
        case .Email:
            break;
            
        }
        
        
        textfield.background = UIImage.backgroundImg(from: PttColors.shark.color)

        textfield.layer.cornerRadius = 15
        textfield.layer.borderColor = PttColors.tangerine.color.cgColor
        textfield.clipsToBounds = true
        textfield.textColor = PttColors.paleGrey.color
        
        textfield.keyboardType = .asciiCapable
        textfield.autocapitalizationType = .none

        textfield.addSubview(self.response!)
    }
    
    func responseLabel() -> UILabel {
        let label = UILabel()
        label.textColor = PttColors.tangerine.color
        label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1)
        
        // TODO: adjust size by parent
        label.frame = CGRect(x: 0, y:0, width: 265-16, height:30)
        label.textAlignment = .right
        label.isUserInteractionEnabled = false
        return label
    }
}
