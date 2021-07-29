//
//  ComposeToolBarView.swift
//  Ptt
//
//  Created by marcus fu on 2021/7/22.
//  Copyright © 2021 Ptt. All rights reserved.
//

import UIKit

protocol ComposeToolBarViewDelegate {
    func deleteCompose()
    func loadDraft()
    func saveDraft()
    func sendCompose()
}

class ComposeToolBarView: UIView {
    var composeToolBarViewDelegate: ComposeToolBarViewDelegate?
    
    lazy var deleteComposeButton: UIButton = {
        let deleteComposeButton = CustomUIToolbarButton(type: .system)
        deleteComposeButton.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        deleteComposeButton.addTarget(target, action: #selector(deleteCompose), for: .touchUpInside)
        deleteComposeButton.imageView?.contentMode = .scaleAspectFit
        deleteComposeButton.tintColor = UIColor(red: 136/255, green: 136/255, blue: 148/255, alpha: 1.0)
        deleteComposeButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(deleteComposeButton)
        return deleteComposeButton
    }()
    
    lazy var loadDraftButton: UIButton = {
        let loadDraftButton = CustomUIToolbarButton(type: .system)
        loadDraftButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        loadDraftButton.addTarget(target, action: #selector(loadDraft), for: .touchUpInside)
        loadDraftButton.imageView?.contentMode = .scaleAspectFit
        loadDraftButton.tintColor = UIColor(red: 136/255, green: 136/255, blue: 148/255, alpha: 1.0)
        loadDraftButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(loadDraftButton)
        return loadDraftButton
    }()
    
    lazy var saveDraftButton: UIButton = {
        let saveDraftButton = CustomUIToolbarButton(type: .system)
        saveDraftButton.setImage(UIImage(systemName: "square.and.arrow.down.fill"), for: .normal)
        saveDraftButton.addTarget(target, action: #selector(saveDraft), for: .touchUpInside)
        saveDraftButton.imageView?.contentMode = .scaleAspectFit
        saveDraftButton.tintColor = UIColor(red: 136/255, green: 136/255, blue: 148/255, alpha: 1.0)
        saveDraftButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(saveDraftButton)
        return saveDraftButton
    }()
    
    lazy var sendComposeButton: UIButton = {
        let sendComposeButton = CustomUIToolbarButton(type: .system)
        sendComposeButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        sendComposeButton.addTarget(target, action: #selector(sendCompose), for: .touchUpInside)
        sendComposeButton.imageView?.contentMode = .scaleAspectFit
        sendComposeButton.tintColor = UIColor(red: 136/255, green: 136/255, blue: 148/255, alpha: 1.0)
        sendComposeButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(sendComposeButton)
        return sendComposeButton
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [deleteComposeButton, loadDraftButton, saveDraftButton, sendComposeButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal,
                           toItem: self, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: stackView, attribute: .centerX, relatedBy: .equal,
                           toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: stackView, attribute: .leading, relatedBy: .equal,
                           toItem: self, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: stackView, attribute: .bottom, relatedBy: .equal,
                           toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
    
    @objc private func deleteCompose() {
        print("deleteCompose")
        composeToolBarViewDelegate?.deleteCompose()
    }
    
    @objc private func loadDraft() {
        print("loadDraft")
        composeToolBarViewDelegate?.loadDraft()
    }
    
    @objc private func saveDraft() {
        print("saveDraft")
        composeToolBarViewDelegate?.saveDraft()
    }
    
    @objc private func sendCompose() {
        print("sendCompose VVVVVVVVVVVVVVVVVVVVVVV")
        composeToolBarViewDelegate?.sendCompose()
    }
    
}

class CustomUIToolbarButton: UIButton {
    override var isHighlighted: Bool {
        didSet {
            if (isHighlighted) {
                self.tintColor = GlobalAppearance.tintColor
            }
            else {
                self.tintColor = UIColor(red: 136/255, green: 136/255, blue: 148/255, alpha: 1.0)
            }

        }
    }
}
