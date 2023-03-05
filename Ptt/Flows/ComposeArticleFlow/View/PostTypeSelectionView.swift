//
//  PostTypeSelectionView.swift
//  Ptt
//
//  Created by AnsonChen on 2023/3/5.
//  Copyright © 2023 Ptt. All rights reserved.
//

import UIKit

protocol PostTypeSelectionDelegate: AnyObject {
    func select(postType: String)
}

final class PostTypeSelectionView: UIView {
    private let postTypes: [String]
    private let tableView: UITableView
    private let cellID = "PostTypeSelectionCell"
    private let cellHeight: CGFloat = 48
    private let headerHeight: CGFloat = 75
    private let footerHeight: CGFloat = 60
    private weak var delegate: PostTypeSelectionDelegate?

    init(postTypes: [String]) {
        self.postTypes = postTypes
        self.tableView = UITableView(frame: .zero, style: .grouped)
        super.init(frame: .zero)
        setUpTableView()
        backgroundColor = PttColors.codGray.color.withAlphaComponent(0.8)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func present(at parent: UIView, delegate: PostTypeSelectionDelegate) {
        self.delegate = delegate
        parent.addSubview(self)
        [
            topAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.topAnchor),
            leadingAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.leadingAnchor),
            trailingAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.trailingAnchor),
            bottomAnchor.constraint(equalTo: parent.bottomAnchor)
        ].active()
    }

    func dismiss() {
        removeFromSuperview()
    }
}

extension PostTypeSelectionView {
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = PttColors.shark.color
        tableView.bounces = false
        tableView.layer.cornerRadius = 10
        tableView.contentInset = .init(top: 0, left: 0, bottom: -20, right: 0);
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0.0
        }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)

        addSubview(tableView)
        let height = CGFloat(postTypes.count) * cellHeight + headerHeight + footerHeight
        [
            tableView.widthAnchor.constraint(equalToConstant: 266),
            tableView.centerXAnchor.constraint(equalTo: centerXAnchor),
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 13),
            tableView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -8),
            tableView.heightAnchor.constraint(equalToConstant: height).set(priority: .defaultLow)
        ].active()
    }

    @objc
    private func clickCancelButton() {
        dismiss()
    }
}

extension PostTypeSelectionView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        let label = UILabel(frame: .zero)
        label.text = L10n.postTypeSelection
        label.textColor = PttColors.paleGrey.color
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        view.addSubview(label)
        [
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ].active()
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        75
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let button = UIButton(frame: .zero)
        button.setTitle(L10n.cancel, for: .normal)
        button.setTitleColor(PttColors.blueGrey.color, for: .normal)
        button.addTarget(self, action: #selector(clickCancelButton), for: .touchUpInside)
        return button
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        60
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        postTypes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = postTypes[indexPath.row]
        cell.textLabel?.textColor = PttColors.tangerine.color
        cell.textLabel?.textAlignment = .center
        cell.backgroundColor = .clear
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        48
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.select(postType: postTypes[indexPath.row])
        dismiss()
    }
}
