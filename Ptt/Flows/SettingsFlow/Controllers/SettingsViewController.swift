//
//  SettingsViewController.swift
//  Ptt
//
//  Created by denkeni on 2021/1/14.
//  Copyright © 2021 Ptt. All rights reserved.
//

import UIKit

final class SettingsViewController: UITableViewController {

    private let cellReuseIdentifier = "SettingsCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Settings", comment: "")
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }

        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! SettingsTableViewCell
        cell.textLabel?.text = "Hello"
        cell.detailTextLabel?.text = "World"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

// MARK: -

private final class SettingsTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)

        backgroundColor = GlobalAppearance.backgroundColor
        if #available(iOS 11.0, *) {
            textLabel?.textColor = UIColor(named: "textColor-240-240-247")
            detailTextLabel?.textColor = UIColor(named: "textColorGray")
        } else {
            textLabel?.textColor = UIColor(red: 240/255, green: 240/255, blue: 247/255, alpha: 1.0)
            detailTextLabel?.textColor = .systemGray
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
