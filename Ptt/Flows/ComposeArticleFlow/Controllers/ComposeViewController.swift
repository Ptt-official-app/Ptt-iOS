//
//  ComposeViewController.swift
//  Ptt
//
//  Created by AnsonChen on 2023/3/4.
//  Copyright © 2023 Ptt. All rights reserved.
//

import UIKit

final class ComposeViewController: UIViewController {
    let customView = ComposeView(frame: .zero)
    let postTypeSelectionView: PostTypeSelectionView
    let viewModel: CViewModel

    override func loadView() {
        self.view = customView
    }

    init(viewModel: CViewModel) {
        self.viewModel = viewModel
        self.postTypeSelectionView = PostTypeSelectionView(postTypes: viewModel.postTypes)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpToolBar()
        setUpComponents()
        observeKeyboards()
    }
}

// MARK: - Set up views
extension ComposeViewController {
    private func setUpNavigation() {
        let leftBarButton = UIButton()
        leftBarButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        leftBarButton.imageView?.layer.transform = CATransform3DMakeScale(1.3 , 1.3 , 1.3)
        leftBarButton.imageView?.tintColor = PttColors.paleGrey.color
        leftBarButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -12, bottom: 0, right: 0)

        leftBarButton.setTitle(L10n.editArticle, for: .normal)
        leftBarButton.setTitleColor(PttColors.paleGrey.color, for: .normal)
        leftBarButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarButton)
    }

    private func setUpToolBar() {
        navigationController?.isToolbarHidden = false
        let bar = makeToolBar(itemData: [
            ("trash.fill", #selector(deleteCompose)),
//            ("square.and.pencil", #selector(loadDraft)),
//            ("archivebox.fill", #selector(saveDraft)),
            ("paperplane.fill",  #selector(sendCompose))
        ])
        toolbarItems = bar.items
    }

    private func setUpComponents() {
        customView.contentTextView.delegate = self
        customView.postTypeButton.addTarget(self, action: #selector(selectPostType), for: .touchUpInside)
        setUpTitleToolBar()
        setUpContentToolBar()
    }

    private func setUpContentToolBar() {
        let bar = makeToolBar(itemData: [
//            ("photo.fill", #selector(uploadPhoto)),
//            ("paintpalette.fill", #selector(openPaintPalette)),
            ("paperplane.fill",#selector(sendCompose)),
            ("keyboard.chevron.compact.down.fill", #selector(dismissKeyboard))
        ])
        customView.contentTextView.inputAccessoryView = bar
    }

    private func setUpTitleToolBar() {
        let bar = makeToolBar(itemData: [("keyboard.chevron.compact.down.fill", #selector(dismissKeyboard))])
        customView.titleField.inputAccessoryView = bar
    }

    private func makeToolBar(itemData: [(String, Selector)]) -> UIToolbar {
        let bar = UIToolbar(frame: .init(x: 0, y: 0, width: view.bounds.width, height: 50))
        let barSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        var barItems: [UIBarButtonItem] = [barSpace]
        for data in itemData {
            let item = UIBarButtonItem(
                image: UIImage(systemName: data.0),
                style: .plain,
                target: self,
                action: data.1
            )
            item.tintColor = .lightGray
            barItems.append(item)
            barItems.append(barSpace)
        }
        bar.items = barItems
        bar.sizeToFit()
        return bar
    }

    private func observeKeyboards() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidChangeFrame),
            name: UIResponder.keyboardDidChangeFrameNotification,
            object: nil
        )
    }
}

// MARK: - Action
extension ComposeViewController {
    @objc
    private func back() {
        navigationController?.dismiss(animated: true)
    }

    @objc
    private func deleteCompose() {

    }

    @objc
    private func loadDraft() {

    }

    @objc
    private func saveDraft() {

    }

    @objc
    private func sendCompose() {

    }

    @objc
    private func uploadPhoto() {

    }

    @objc
    private func openPaintPalette() {

    }

    @objc
    private func dismissKeyboard() {
        customView.titleField.resignFirstResponder()
        customView.contentTextView.resignFirstResponder()
    }

    @objc
    private func selectPostType() {
        // TODO: `posttype` in https://doc.devptt.dev/#/board/get_api_board__bid_
        // But `posttype` is a string, will be updated to `posttypes`
        postTypeSelectionView.present(at: view, delegate: self)
    }

    @objc
    private func keyboardDidChangeFrame(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardSize = userInfo["UIKeyboardFrameEndUserInfoKey"] as? CGRect else { return }
        customView.scrollViewBottom?.constant = -1 * keyboardSize.height + 81
    }

    @objc
    private func keyboardWillHide(notification: Notification) {
        customView.scrollViewBottom?.constant = 0
    }
}

// MARK: UITextViewDelegate
extension ComposeViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == L10n.inputArticleContent {
            textView.text = ""
            textView.textColor = PttColors.paleGrey.color
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        let text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if text.isEmpty {
            textView.text = L10n.inputArticleContent
            textView.textColor = PttColors.charcoalGrey.color
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        
    }
}

extension ComposeViewController: PostTypeSelectionDelegate {
    func select(postType: String) {
        customView.postTypeButton.setTitle(postType, for: .normal)
        customView.postTypeButton.setTitleColor(PttColors.tangerine.color, for: .normal)
        viewModel.update(postType: postType)
    }
}
