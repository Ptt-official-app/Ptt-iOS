// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
enum PttColors {
  static let black = ColorAsset(name: "black")
  static let blueGrey = ColorAsset(name: "blueGrey")
  static let brightLilac = ColorAsset(name: "brightLilac")
  static let charcoalGrey = ColorAsset(name: "charcoalGrey")
  static let codGray = ColorAsset(name: "codGray")
  static let coral = ColorAsset(name: "coral")
  static let dandelion = ColorAsset(name: "dandelion")
  static let darkGrey = ColorAsset(name: "darkGrey")
  static let darkMint = ColorAsset(name: "darkMint")
  static let darkPeriwinkle = ColorAsset(name: "darkPeriwinkle")
  static let deepSkyBlue = ColorAsset(name: "deepSkyBlue")
  static let frenchGray = ColorAsset(name: "frenchGray")
  static let lightBlueGrey = ColorAsset(name: "lightBlueGrey")
  static let paleGrey = ColorAsset(name: "paleGrey")
  static let paleLilac = ColorAsset(name: "paleLilac")
  static let palePurple = ColorAsset(name: "palePurple")
  static let reddishPink = ColorAsset(name: "reddishPink")
  static let robinSEgg = ColorAsset(name: "robinSEgg")
  static let shark = ColorAsset(name: "shark")
  static let slateGrey = ColorAsset(name: "slateGrey")
  static let tangerine = ColorAsset(name: "tangerine")
  static let tuna = ColorAsset(name: "tuna")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

final class ColorAsset {
  fileprivate(set) var name: String

  #if os(macOS)
  typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
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

