//
//  ComposeArticleView.swift
//  Ptt
//
//  Created by AnsonChen on 2023/3/4.
//  Copyright © 2023 Ptt. All rights reserved.
//

import UIKit

final class ComposeArticleView: UIView {
    private let container = ComposeArticleView.container()
    private let scrollView = ComposeArticleView.scrollView()
    private(set) var scrollViewBottom: NSLayoutConstraint?
    let postTypeButton = ComposeArticleView.postTypeButton()
    let titleField = ComposeArticleView.titleField()
    let contentTextView = ComposeArticleView.contentTextView()
    let loadingView = ComposeArticleView.loadingView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }

    private func setUp() {
        backgroundColor = PttColors.codGray.color
        setUpScrollView()
        setUpContainer()
        setUpPostTypeButton()
        setUpTitleField()
        setUpContentTextView()
        setUpLoadingView()
    }

    private func setUpScrollView() {
        addSubview(scrollView)
        [
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.heightAnchor.constraint(equalTo: heightAnchor).set(priority: .defaultLow)
        ].active()
        scrollViewBottom = scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        scrollViewBottom?.isActive = true
    }

    private func setUpContainer() {
        scrollView.addSubview(container)
        [
            container.topAnchor.constraint(equalTo: scrollView.topAnchor),
            container.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            container.heightAnchor.constraint(equalTo: scrollView.heightAnchor).set(priority: .defaultLow),
            container.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ].active()
    }

    private func setUpPostTypeButton() {
        container.addSubview(postTypeButton)
        [
            postTypeButton.topAnchor.constraint(equalTo: container.topAnchor, constant: 29),
            postTypeButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 24),
            postTypeButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 17)
        ].active()
    }

    private func setUpTitleField() {
        container.addSubview(titleField)
        [
            titleField.topAnchor.constraint(equalTo: postTypeButton.bottomAnchor, constant: 25),
            titleField.leadingAnchor.constraint(equalTo: postTypeButton.leadingAnchor),
            titleField.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -24),
            titleField.heightAnchor.constraint(greaterThanOrEqualToConstant: 29)
        ].active()

        let line = UIView(frame: .zero)
        line.backgroundColor = PttColors.tuna.color
        container.addSubview(line)
        [
            line.leadingAnchor.constraint(equalTo: titleField.leadingAnchor),
            line.trailingAnchor.constraint(equalTo: titleField.trailingAnchor),
            line.topAnchor.constraint(equalTo: titleField.bottomAnchor),
            line.heightAnchor.constraint(equalToConstant: 1)
        ].active()
    }

    private func setUpContentTextView() {
        container.addSubview(contentTextView)
        [
            contentTextView.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 29),
            contentTextView.leadingAnchor.constraint(equalTo: titleField.leadingAnchor),
            contentTextView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -24),
            contentTextView.bottomAnchor.constraint(lessThanOrEqualTo: container.bottomAnchor, constant: -25),
            contentTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
        ].active()
    }

    private func setUpLoadingView() {
        addSubview(loadingView)
        loadingView.isHidden = true

        [
            loadingView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ].active()
    }
}

// MARK: - Components
extension ComposeArticleView {
    private static func scrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = PttColors.shark.color
        return scrollView
    }

    private static func container() -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        return view
    }

    private static func postTypeButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle(L10n.postTypeSelection, for: .normal)
        button.setTitleColor(PttColors.paleGrey.color, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        return button
    }

    private static func titleField() -> UITextField {
        let titleField = UITextField()
        titleField.placeholder = L10n.inputArticleTitle
        titleField.font = UIFont.boldSystemFont(ofSize: 24)
        titleField.textColor = PttColors.paleGrey.color
        titleField.backgroundColor = .clear
        return titleField
    }

    private static func contentTextView() -> UITextView {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.text = L10n.inputArticleContent
        textView.textColor = PttColors.charcoalGrey.color
        textView.font = .systemFont(ofSize: 18)
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        textView.isScrollEnabled = false
        textView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        textView.autocorrectionType = .no
        return textView
    }

    private static func loadingView() -> LoadingView {
        let view = LoadingView()
        return view
    }
}
