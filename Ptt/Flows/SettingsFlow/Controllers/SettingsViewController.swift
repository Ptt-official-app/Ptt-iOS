//
//  SettingsViewController.swift
//  Ptt
//
//  Created by denkeni on 2021/1/14.
//  Copyright © 2021 Ptt. All rights reserved.
//

import UIKit
import WebKit

private enum SettingsSection : Int, CaseIterable {
    case main, about
}

private enum SettingsMainRow : Int, CaseIterable {
    case appearance, address, cache
}

private enum SettingsAboutRow : Int, CaseIterable {
    case license, version
}

final class SettingsViewController: UITableViewController {

    private let cellReuseIdentifier = "SettingsCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Settings", comment: "")
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        view.backgroundColor = GlobalAppearance.backgroundColor

        if #available(iOS 13.0, *) {
        } else {
            tableView.separatorStyle = .none
        }
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)

        NotificationCenter.default.addObserver(self, selector: #selector(didChangeAppearanceMode), name: NotificationName.value(of: .didChangeAppearanceMode), object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: true)
        }
    }

    @objc private func didChangeAppearanceMode() {
        let indexPath = IndexPath(row: SettingsMainRow.appearance.rawValue,
                                  section: SettingsSection.main.rawValue)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSection.allCases.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionType = SettingsSection(rawValue: section) else {
            return nil
        }
        switch sectionType {
        case .main:
            return nil
        case .about:
            return NSLocalizedString("About This Software", comment: "")
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = SettingsSection(rawValue: section) else {
            return 0
        }
        switch sectionType {
        case .main:
            return SettingsMainRow.allCases.count
        case .about:
            return SettingsAboutRow.allCases.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! SettingsTableViewCell
        guard let sectionType = SettingsSection(rawValue: indexPath.section) else { return cell }
        switch sectionType {
        case .main:
            guard let rowType = SettingsMainRow(rawValue: indexPath.row) else { return cell }
            switch rowType {
            case .appearance:
                var text = NSLocalizedString("Appearance Mode", comment: "")
                if #available(iOS 13.0, *) {
                    cell.type = .disclosure
                } else {
                    text += " (iOS 13)"
                    cell.type = .plain
                }
                cell.textLabel?.text = text
                switch UserDefaultsManager.appearanceMode() {
                case .system:
                    cell.detailTextLabel?.text = NSLocalizedString("System Default", comment: "")
                case .light:
                    cell.detailTextLabel?.text = NSLocalizedString("Light", comment: "")
                case .dark:
                    cell.detailTextLabel?.text = NSLocalizedString("Dark", comment: "")
                }
            case .address:
                cell.textLabel?.text = NSLocalizedString("Site Address", comment: "")
                cell.detailTextLabel?.text = UserDefaultsManager.addressForDisplay
                cell.type = .disclosure
            case .cache:
                cell.textLabel?.text = NSLocalizedString("Clear Cache", comment: "")
                cell.type = .action
            }
        case .about:
            guard let rowType = SettingsAboutRow(rawValue: indexPath.row) else { return cell }
            switch rowType {
            case .license:
                cell.textLabel?.text = NSLocalizedString("Third Party License", comment: "")
                cell.type = .disclosure
            case .version:
                cell.textLabel?.text = NSLocalizedString("Version", comment: "")
                if let bundle = Bundle.main.infoDictionary, let version = bundle["CFBundleShortVersionString"] as? String, let build = bundle["CFBundleVersion"] as? String {
                    cell.detailTextLabel?.text = "\(version) (\(build))"
                }
                cell.type = .plain
            }
        }
        return cell
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sectionType = SettingsSection(rawValue: indexPath.section) else { return }
        switch sectionType {
        case .main:
            guard let rowType = SettingsMainRow(rawValue: indexPath.row) else { return }
            switch rowType {
            case .appearance:
                if #available(iOS 13.0, *) {
                    let appearanceModeViewController = AppearanceModeViewController(style: .insetGrouped)
                    show(appearanceModeViewController, sender: self)
                } else {
                    let alert = UIAlertController(title: nil, message: NSLocalizedString("Changing this value requires iOS 13 or later.", comment: ""), preferredStyle: .alert)
                    let confirm = UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .default, handler: nil)
                    alert.addAction(confirm)
                    present(alert, animated: true, completion: nil)
                }
            case .address:
                tableView.deselectRow(at: indexPath, animated: true)
                let prompt = UIAlertController(title: NSLocalizedString("Change Site Address", comment: ""),
                                              message: NSLocalizedString("Leave it blank for default value", comment: ""),
                                              preferredStyle: .alert)
                prompt.addTextField { (textField) in
                    textField.placeholder = UserDefaultsManager.addressDefaultForDisplay
                }
                let confirm = UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .default) { (action) in
                    guard var text = prompt.textFields?.first?.text else { return }
                    if text == "" {
                        text = UserDefaultsManager.addressDefaultForDisplay
                    }
                    let success = UserDefaultsManager.set(address: text)
                    if !success {
                        let alert = UIAlertController(title: NSLocalizedString("Wrong Format", comment: ""), message: nil, preferredStyle: .alert)
                        let confirm = UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .default, handler: nil)
                        alert.addAction(confirm)
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    let indexPath = IndexPath(row: SettingsMainRow.address.rawValue,
                                              section: SettingsSection.main.rawValue)
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
                let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
                prompt.addAction(confirm)
                prompt.addAction(cancel)
                present(prompt, animated: true, completion: nil)
                break
            case .cache:
                tableView.deselectRow(at: indexPath, animated: true)
                let alert = UIAlertController(title: NSLocalizedString("Are you sure to clear cache?", comment: ""), message: nil, preferredStyle: .alert)
                let confirm = UIAlertAction(title: NSLocalizedString("Clear", comment: ""), style: .destructive) { (action) in
                    HTTPCookieStorage.shared.removeCookies(since: .distantPast)
                    // Remove URL cache (Library/Caches/{bundle_id}/fsCachedData/*)
                    URLCache.shared.removeAllCachedResponses()
                    // Removing WKWebView cache (Library/Caches/{bundle_id}/WebKit/*)
                    // However, WebKit/NetworkCache/* not get deleted...
                    let store = WKWebsiteDataStore.default()
                    let dataType = WKWebsiteDataStore.allWebsiteDataTypes()
                    store.fetchDataRecords(ofTypes: dataType) { (records) in
                        store.removeData(ofTypes: dataType, for: records, completionHandler: {})
                    }
                }
                let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
                alert.addAction(confirm)
                alert.addAction(cancel)
                present(alert, animated: true, completion: nil)
            }
        case .about:
            guard let rowType = SettingsAboutRow(rawValue: indexPath.row) else { return }
            switch rowType {
            case .license:
                let vc = LicenseViewController()
                show(vc, sender: self)
            default:
                break
            }
        }
    }
}

// MARK: -

final class SettingsTableViewCell: UITableViewCell {

    enum SettingsCellType {
        case plain, disclosure, selectable, action
    }

    var type : SettingsCellType = .plain {
        didSet {
            switch type {
            case .plain:
                updateColor(isActionable: false)
                accessoryType = .none
                selectionStyle = .none
            case .disclosure:
                updateColor(isActionable: false)
                accessoryType = .disclosureIndicator
                selectionStyle = .default
            case .selectable:
                updateColor(isActionable: false)
                accessoryType = .none
                selectionStyle = .default
            case .action:
                updateColor(isActionable: true)
                accessoryType = .none
                selectionStyle = .default
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)

        if #available(iOS 11.0, *) {
            backgroundColor = UIColor(named: "blackColor-28-28-31")
        } else {
            backgroundColor = UIColor(red: 28/255, green: 28/255, blue: 31/255, alpha: 1.0)
        }
        self.type = .plain
    }

    private func updateColor(isActionable: Bool) {
        switch isActionable {
        case true:
            textLabel?.textColor = GlobalAppearance.tintColor
            detailTextLabel?.textColor = .clear
        case false:
            if #available(iOS 11.0, *) {
                textLabel?.textColor = UIColor(named: "textColor-240-240-247")
                detailTextLabel?.textColor = UIColor(named: "textColorGray")
            } else {
                textLabel?.textColor = UIColor(red: 240/255, green: 240/255, blue: 247/255, alpha: 1.0)
                detailTextLabel?.textColor = .systemGray
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
