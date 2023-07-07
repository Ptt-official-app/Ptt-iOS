//
//  LicenseViewController.swift
//  Ptt
//
//  Created by denkeni on 2021/1/14.
//  Copyright © 2021 Ptt. All rights reserved.
//

import UIKit

final class LicenseViewController: UITableViewController, FullscreenSwipeable {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = L10n.thirdPartyLicense
        tableView.backgroundColor = GlobalAppearance.backgroundColor
        enableFullscreenSwipeBack()

        tableView.backgroundColor = GlobalAppearance.backgroundColor
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.register(LicenseCell.self, forCellReuseIdentifier: "LicenseCell")
    }
}

// MARK: - UITableViewDataSource

extension LicenseViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LicenseCell", for: indexPath)
        return cell
    }
}

private class LicenseCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = GlobalAppearance.backgroundColor
        selectionStyle = .none

        let textColor: UIColor
        if #available(iOS 11.0, *) {
            textColor = PttColors.paleGrey.color
        } else {
            textColor = UIColor(red: 240 / 255, green: 240 / 255, blue: 247 / 255, alpha: 1.0)
        }
        let attributes = [NSAttributedString.Key.foregroundColor: textColor]
        let licenses = [
            LicenseViewController.swiftGenerateLicense
        ].joined(separator: "\n\n")

        textLabel?.numberOfLines = 0
        textLabel?.attributedText = NSAttributedString(string: licenses, attributes: attributes)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LicenseViewController {

    static let swiftGenerateLicense = """
    # SwiftGen
    https://github.com/SwiftGen/SwiftGen/blob/stable/LICENCE

    MIT Licence

    Copyright (c) 2020 SwiftGen

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.

    # SwiftLint
    https://github.com/realm/SwiftLint

    The MIT License (MIT)

    Copyright (c) 2020 Realm Inc.

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
    """
}
