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

class LoginTextField : UITextField {

    var type: TextFieldType = .Username
    var lbResponse:UILabel?
    var btnTogglePassword:UIButton?
    
    var title: String? = nil {
        didSet {
            guard let title = title else { return }
            
            let attr:[NSAttributedString.Key : Any] = [
                NSAttributedString.Key.foregroundColor: PttColors.paleGrey.color,
                NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1)
            ]
            self.attributedPlaceholder = NSAttributedString.init(string: title, attributes:attr)
        }
    }
    
    override var frame: CGRect {
        didSet {
            //print("ltf frame did set:", frame)
            
            self.lbResponse?.frame = CGRect(x: 0, y:0, width: self.frame.width - 16, height:30)
        }
    }

    var textPadding = UIEdgeInsets(
        top: 0,
        left: 20,
        bottom: 0,
        right: 20
    )

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    
    init(type: TextFieldType) {
        // TODO: may not work for init in ASDisplay note
        print("May not work with ASDisplayNode.init")
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        self.type = type
        _init()
    }
    
    func _init() {
        lbResponse = self.responseLabel()
        
        
        self.keyboardType = .asciiCapable
        
        switch type {
        case .Username:
            break
        case .Password:
            self.isSecureTextEntry = true
            self.rightViewMode = .always
            self.btnTogglePassword = getButton()
            self.rightView = self.btnTogglePassword
        case .Email:
            keyboardType = .emailAddress
            break;
        }
        
        self.background = UIImage.backgroundImg(from: PttColors.shark.color)

        self.layer.cornerRadius = 15
        self.layer.borderColor = PttColors.tangerine.color.cgColor
        self.clipsToBounds = true
        self.textColor = PttColors.paleGrey.color
        
        
        self.autocapitalizationType = .none

        self.addSubview(self.lbResponse!)
    }
    
    
    func warning(msg:String?){
        if let m = msg {
            lbResponse?.text = m
            self.layer.borderWidth = 1
        }
        else {
            lbResponse?.text = ""
            self.layer.borderWidth = 0
        }
        
    }
    
    @objc func togglePassword() {
        print("toggle in ui event");
        if let btn = self.btnTogglePassword {
            btn.isSelected = !btn.isSelected
        }
        //self.btnTooglePassword?.isSelected = !self.btnTooglePassword?.isSelected
        
        self.isSecureTextEntry = !self.isSecureTextEntry
    }
    
    func getButton() -> UIButton{
        let btn = UIButton()
        btn.frame = CGRect(x:0, y:0, width:44, height:44)
        if #available(iOS 12.0, *) {
            btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        }
        btn.setImage(StyleKit.imageOfPasswdVisibilitySelected(), for: UIControl.State.selected)
        btn.setImage(StyleKit.imageOfPasswdVisibility(), for: UIControl.State.normal)

        btn.addTarget(self, action: #selector(self.togglePassword), for: UIControl.Event.touchDown)
        return btn
    }

    
    func responseLabel() -> UILabel {
        let label = UILabel()
        label.textColor = PttColors.tangerine.color
        label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1)
        
        // TODO: adjust size by frame did set
        label.frame = CGRect(x: 0, y:0, width: self.frame.width - 16, height:30)
        label.textAlignment = .right
        label.isUserInteractionEnabled = false
        return label
    }
}
