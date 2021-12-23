// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
enum L10n {
  /// About This Software
  static let aboutThisSoftware = L10n.tr("Localizable", "About This Software")
  /// Adds
  static let adds = L10n.tr("Localizable", "Adds")
  /// ALL
  static let all = L10n.tr("Localizable", "ALL")
  /// Appearance Mode
  static let appearanceMode = L10n.tr("Localizable", "Appearance Mode")
  /// Are you sure to clear cache?
  static let areYouSureToClearCache = L10n.tr("Localizable", "Are you sure to clear cache?")
  /// Cancel
  static let cancel = L10n.tr("Localizable", "Cancel")
  /// Change Site Address
  static let changeSiteAddress = L10n.tr("Localizable", "Change Site Address")
  /// Changing this value requires iOS 13 or later.
  static let changingThisValueRequiresIOS13OrLater = L10n.tr("Localizable", "Changing this value requires iOS 13 or later.")
  /// Clear
  static let clear = L10n.tr("Localizable", "Clear")
  /// Clear Cache
  static let clearCache = L10n.tr("Localizable", "Clear Cache")
  /// Compose
  static let compose = L10n.tr("Localizable", "Compose")
  /// Confirm
  static let confirm = L10n.tr("Localizable", "Confirm")
  /// Customization Mode
  static let customizationMode = L10n.tr("Localizable", "Customization Mode")
  /// Dark
  static let dark = L10n.tr("Localizable", "Dark")
  /// Error
  static let error = L10n.tr("Localizable", "Error")
  /// Favorite Boards
  static let favoriteBoards = L10n.tr("Localizable", "Favorite Boards")
  /// FB Page
  static let fbPage = L10n.tr("Localizable", "FB Page")
  /// Forget
  static let forget = L10n.tr("Localizable", "Forget")
  /// from favorite.
  static let fromFavorite = L10n.tr("Localizable", "from favorite.")
  /// Hot Topics
  static let hotTopics = L10n.tr("Localizable", "Hot Topics")
  /// In favorite
  static let inFavorite = L10n.tr("Localizable", "In favorite")
  /// Leave it blank for default value
  static let leaveItBlankForDefaultValue = L10n.tr("Localizable", "Leave it blank for default value")
  /// Light
  static let light = L10n.tr("Localizable", "Light")
  /// Login
  static let login = L10n.tr("Localizable", "Login")
  /// More actions
  static let moreActions = L10n.tr("Localizable", "More actions")
  /// Not in favorite
  static let notInFavorite = L10n.tr("Localizable", "Not in favorite")
  /// Password
  static let password = L10n.tr("Localizable", "Password")
  /// Popular Articles
  static let popularArticles = L10n.tr("Localizable", "Popular Articles")
  /// Popular Boards
  static let popularBoards = L10n.tr("Localizable", "Popular Boards")
  /// PTT FB Page
  static let pttfbPage = L10n.tr("Localizable", "PTT FB Page")
  /// Refresh
  static let refresh = L10n.tr("Localizable", "Refresh")
  /// Register
  static let register = L10n.tr("Localizable", "Register")
  /// Removes
  static let removes = L10n.tr("Localizable", "Removes")
  /// Search
  static let search = L10n.tr("Localizable", "Search")
  /// Settings
  static let settings = L10n.tr("Localizable", "Settings")
  /// Site Address
  static let siteAddress = L10n.tr("Localizable", "Site Address")
  /// System Default
  static let systemDefault = L10n.tr("Localizable", "System Default")
  /// Third Party License
  static let thirdPartyLicense = L10n.tr("Localizable", "Third Party License")
  /// to favorite.
  static let toFavorite = L10n.tr("Localizable", "to favorite.")
  /// Use System Default
  static let useSystemDefault = L10n.tr("Localizable", "Use System Default")
  /// Username
  static let username = L10n.tr("Localizable", "Username")
  /// Version
  static let version = L10n.tr("Localizable", "Version")
  /// Wrong Format
  static let wrongFormat = L10n.tr("Localizable", "Wrong Format")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type

