// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal enum Assets {
    internal static let alarmDefault = ImageAsset(name: "alarm_default")
    internal static let alarmGray = ImageAsset(name: "alarm_gray")
    internal static let arrowDownGray = ImageAsset(name: "arrow_down_gray")
    internal static let arrowLeftGray = ImageAsset(name: "arrow_left_gray")
    internal static let arrowRightGray = ImageAsset(name: "arrow_right_gray")
    internal static let backDefualt = ImageAsset(name: "back_defualt")
    internal static let checkGray = ImageAsset(name: "check_gray")
    internal static let deleteDefault = ImageAsset(name: "delete_default")
    internal static let deleteRed = ImageAsset(name: "delete_red")
    internal static let deleteWhite = ImageAsset(name: "delete_white")
    internal static let editDefault = ImageAsset(name: "edit_default")
    internal static let editGray = ImageAsset(name: "edit_gray")
    internal static let editWhite = ImageAsset(name: "edit_white")
    internal static let group = ImageAsset(name: "group")
    internal static let locationDefault = ImageAsset(name: "location_default")
    internal static let mapDefault = ImageAsset(name: "map_default")
    internal static let mapGray = ImageAsset(name: "map_gray")
    internal static let settingBlack = ImageAsset(name: "setting_black")
    internal static let settingWhite = ImageAsset(name: "setting_white")
    internal static let settingWhite2 = ImageAsset(name: "setting_white2")
    internal static let today = ImageAsset(name: "today")
    internal static let uncheckDefault = ImageAsset(name: "uncheck_default")
    internal static let logo = ImageAsset(name: "logo")
  }
  internal enum Color {
    internal static let `default` = ColorAsset(name: "Default")
    internal static let end1 = ColorAsset(name: "End1")
    internal static let end2 = ColorAsset(name: "End2")
    internal static let end3 = ColorAsset(name: "End3")
    internal static let end4 = ColorAsset(name: "End4")
    internal static let end5 = ColorAsset(name: "End5")
    internal static let end6 = ColorAsset(name: "End6")
    internal static let end7 = ColorAsset(name: "End7")
    internal static let end8 = ColorAsset(name: "End8")
    internal static let end9 = ColorAsset(name: "End9")
    internal static let start1 = ColorAsset(name: "Start1")
    internal static let start2 = ColorAsset(name: "Start2")
    internal static let start3 = ColorAsset(name: "Start3")
    internal static let start4 = ColorAsset(name: "Start4")
    internal static let start5 = ColorAsset(name: "Start5")
    internal static let start6 = ColorAsset(name: "Start6")
    internal static let start7 = ColorAsset(name: "Start7")
    internal static let start8 = ColorAsset(name: "Start8")
    internal static let start9 = ColorAsset(name: "Start9")
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal private(set) lazy var swiftUIColor: SwiftUI.Color = {
    SwiftUI.Color(asset: self)
  }()
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
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

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Color {
  init(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }
}
#endif

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal var swiftUIImage: SwiftUI.Image {
    SwiftUI.Image(asset: self)
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Image {
  init(asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }

  init(asset: ImageAsset, label: Text) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle, label: label)
  }

  init(decorative asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(decorative: asset.name, bundle: bundle)
  }
}
#endif

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
