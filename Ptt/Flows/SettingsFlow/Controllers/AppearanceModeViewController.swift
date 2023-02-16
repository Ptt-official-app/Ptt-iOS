//
//  AppearanceModeViewController.swift
//  Ptt
//
//  Created by denkeni on 2021/1/14.
//  Copyright © 2021 Ptt. All rights reserved.
//

import UIKit

private enum AppearanceModeSection: Int, CaseIterable {
    case system, customization
}

private enum AppearanceModeSystemRow: Int, CaseIterable {
    case system
}

private enum AppearanceModeCustomizationRow: Int, CaseIterable {
    case light, dark
}

@available(iOS 13.0, *)
final class AppearanceModeViewController: UITableViewController, FullscreenSwipeable {

    private let cellReuseIdentifier = "AppearanceModeCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        title = L10n.appearanceMode
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = GlobalAppearance.backgroundColor
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)

        enableFullscreenSwipeBack()
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        switch UserDefaultsManager.appearanceMode() {
        case .system:
            return 1
        default:
            return 2
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionType = AppearanceModeSection(rawValue: section) else { return nil }
        switch sectionType {
        case .customization:
            return L10n.customizationMode
        default:
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = AppearanceModeSection(rawValue: section) else { return 0 }
        switch sectionType {
        case .system:
            return AppearanceModeSystemRow.allCases.count
        case .customization:
            return AppearanceModeCustomizationRow.allCases.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! SettingsTableViewCell

        guard let sectionType = AppearanceModeSection(rawValue: indexPath.section) else { return cell }
        switch sectionType {
        case .system:
            cell.type = .plain
            guard let rowType = AppearanceModeSystemRow(rawValue: indexPath.row) else { return cell }
            switch rowType {
            case .system:
                cell.textLabel?.text = L10n.useSystemDefault
                let switchControl = UISwitch()
                switchControl.onTintColor = GlobalAppearance.tintColor
                switchControl.isOn = (UserDefaultsManager.appearanceMode() == .system)
                switchControl.addTarget(self, action: #selector(useSystemDefault), for: .valueChanged)
                cell.accessoryView = switchControl
            }
        case .customization:
            cell.type = .selectable
            guard let rowType = AppearanceModeCustomizationRow(rawValue: indexPath.row) else { return cell }
            switch rowType {
            case .light:
                cell.textLabel?.text = L10n.light
                if UserDefaultsManager.appearanceMode() == .light {
                    cell.accessoryType = .checkmark
                }
                updateColor(of: cell, for: .light)
            case .dark:
                cell.textLabel?.text = L10n.dark
                if UserDefaultsManager.appearanceMode() == .dark {
                    cell.accessoryType = .checkmark
                }
                updateColor(of: cell, for: .dark)
            }
        }

        return cell
    }

    /// Special cell customization for visual recognition
    private func updateColor(of cell: UITableViewCell, for type: AppearanceModeCustomizationRow) {
        switch type {
        case .light:
            cell.textLabel?.textColor = .darkText
            cell.backgroundColor = UIColor(red: 0.89, green: 0.89, blue: 0.88, alpha: 1.00) // #E3E3E0, blackColor-28-28-31 light
        case .dark:
            cell.textLabel?.textColor = UIColor(red: 240/255, green: 240/255, blue: 247/255, alpha: 1.0)
            cell.backgroundColor = UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1.00) // #1C1C1F, blackColor-28-28-31 dark
        }
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let sectionType = AppearanceModeSection(rawValue: indexPath.section) else { return }
        switch sectionType {
        case .customization:
            guard let rowType = AppearanceModeCustomizationRow(rawValue: indexPath.row) else { return }
            guard let keyWindow = UIApplication.shared.keyWindow else { return }
            switch rowType {
            case .light:
                keyWindow.overrideUserInterfaceStyle = .light
                UserDefaultsManager.setAppearanceMode(mode: .light)
            case .dark:
                keyWindow.overrideUserInterfaceStyle = .dark
                UserDefaultsManager.setAppearanceMode(mode: .dark)
            }
            selectCustomizationCell(type: rowType)
            NotificationCenter.default.post(name: NotificationName.value(of: .didChangeAppearanceMode), object: nil)
        default:
            break
        }
    }

    private func selectCustomizationCell(type: AppearanceModeCustomizationRow) {
        let light = IndexPath(row: AppearanceModeCustomizationRow.light.rawValue,
                              section: AppearanceModeSection.customization.rawValue)
        let dark = IndexPath(row: AppearanceModeCustomizationRow.dark.rawValue,
                              section: AppearanceModeSection.customization.rawValue)
        switch type {
        case .light:
            tableView.cellForRow(at: light)?.accessoryType = .checkmark
            tableView.cellForRow(at: dark)?.accessoryType = .none
        case .dark:
            tableView.cellForRow(at: light)?.accessoryType = .none
            tableView.cellForRow(at: dark)?.accessoryType = .checkmark
        }
    }

    // MARK: - Actions
    @objc private func useSystemDefault(sender: UISwitch) {
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        switch sender.isOn {
        case true:
            keyWindow.overrideUserInterfaceStyle = .unspecified
            UserDefaultsManager.setAppearanceMode(mode: .system)
            tableView.deleteSections(IndexSet(integer: AppearanceModeSection.customization.rawValue), with: .fade)
        case false:
            keyWindow.overrideUserInterfaceStyle = .dark
            UserDefaultsManager.setAppearanceMode(mode: .dark)
            tableView.insertSections(IndexSet(integer: AppearanceModeSection.customization.rawValue), with: .fade)
        }
        NotificationCenter.default.post(name: NotificationName.value(of: .didChangeAppearanceMode), object: nil)
    }
}
