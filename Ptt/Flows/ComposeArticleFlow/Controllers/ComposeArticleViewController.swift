//
//  ComposeArticleViewController.swift
//  Ptt
//
//  Created by marcus fu on 2021/5/11.
//  Copyright © 2021 Ptt. All rights reserved.
//

import UIKit

final class ComposeArticleViewController: UIViewController {
    private let customView = ComposeArticleView(frame: .zero)
    private let postTypeSelectionView: PostTypeSelectionView
    private let viewModel: ComposeArticleViewModel

    override func loadView() {
        self.view = customView
    }

    init(viewModel: ComposeArticleViewModel) {
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

// MARK: - UI related
extension ComposeArticleViewController {
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
//            ("trash.fill", #selector(deleteCompose)),
//            ("square.and.pencil", #selector(loadDraft)),
//            ("archivebox.fill", #selector(saveDraft)),
            ("paperplane.fill",  #selector(clickSendButton))
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
            ("paperplane.fill",#selector(clickSendButton)),
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

    private func showErrorAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L10n.confirm, style: .default))
        present(alert, animated: true)
    }

    private func showConfirmAlert() {
        let alert = UIAlertController(title: nil, message: L10n.createPostConfirmMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L10n.submit, style: .default, handler: { [weak self] _ in
            self?.createPost()
        }))
        alert.addAction(UIAlertAction(title: L10n.cancel, style: .cancel))
        present(alert, animated: true)
    }

    private func showLoading(shouldShow: Bool) {
        customView.loadingView.isHidden = !shouldShow
    }
}

// MARK: - Action
extension ComposeArticleViewController {
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
    private func clickSendButton() {
        view.endEditing(true)
        let title = customView.titleField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if title.isEmpty {
            showErrorAlert(title: nil, message: L10n.articleTitleIsEmpty)
        } else if viewModel.selectedPostType.isEmpty {
            showErrorAlert(title: nil, message: L10n.postTypeIsEmpty)
        } else {
            showConfirmAlert()
        }
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

    private func createPost() {
        showLoading(shouldShow: false)
        let title = customView.titleField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let content = customView.contentTextView.text ?? ""
        viewModel.createPost(title: title, content: content, completion: { [weak self] result in
            DispatchQueue.main.async {
                self?.showLoading(shouldShow: true)
                switch result {
                case .failure(let error):
                    self?.showErrorAlert(title: L10n.error, message: error.message)
                case .success:
                    NotificationCenter.default.post(name: .didPostNewArticle, object: nil)
                    self?.back()
                }
            }
        })
    }
}

// MARK: UITextViewDelegate
extension ComposeArticleViewController: UITextViewDelegate {
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

extension ComposeArticleViewController: PostTypeSelectionDelegate {
    func select(postType: String) {
        customView.postTypeButton.setTitle(postType, for: .normal)
        customView.postTypeButton.setTitleColor(PttColors.tangerine.color, for: .normal)
        viewModel.update(postType: postType)
    }
}
