//
//  AppTheme.swift
//  Pods
//
//  Created by MacMini-2 on 30/08/17.
//
//

import UIKit

public extension AppColor {

    public var value: UIColor {
        var instanceColor = UIColor.clear

        switch self {

            // TODO: Activity Loader Color
        case .activityLoader: // this will set spinner/activity loader tint color
            instanceColor = UIColor.red
            break

        case .activityLoaderBG:
            instanceColor = UIColor(rgbValue: 0xffffff, alpha: 0.5)
            break

        case .activityText:
            instanceColor = UIColor(rgbValue: 0xffffff, alpha: 0.5)
            break

            // TODO: Bar Button Color
        case .activeBarButtonText:
            instanceColor = UIColor(rgbValue: 0x000000, alpha: 0.5)
            break

        case .disableBarButtonText:
            instanceColor = UIColor(rgbValue: 0xffffff, alpha: 0.5)
            break

        case .barButtonBorder:
            instanceColor = UIColor(rgbValue: 0xffffff, alpha: 0.5)
            break

        case .border: // This will general border color in whole application
            instanceColor = UIColor(rgbValue: 0x333333, alpha: 1.0)
            break

        case .shadow: // This will mainly use for give shadow to view and cell cardview
            instanceColor = UIColor(rgbValue: 0x333333, alpha: 1.0)
            break

            // TODO: Application Background AppColor
        case .appPrimaryBG: // this is application general dark backgroud color
            instanceColor = UIColor(rgbValue: 0x333333, alpha: 1.0)
            break

        case .appSecondaryBG: // this is application general light backgroud color
            instanceColor = UIColor(rgbValue: 0xeeeeee, alpha: 1.0)
            break

        case .appIntermidiateBG: // this is application general intermidiate backgroud color
            instanceColor = UIColor(rgbValue: 0x202020, alpha: 1.0)
            break

            // TODO: UITextField / UITextView
        case .textFieldBG:
            instanceColor = UIColor(rgbValue: 0xDCDCDC, alpha: 1.0)
            break

        case .textFieldText:
            instanceColor = UIColor(rgbValue: 0x000000, alpha: 1.0)
            break

        case .textFieldBorder:
            instanceColor = UIColor(rgbValue: 0xDCDCDC, alpha: 1.0)
            break

        case .textFieldErrorBorder:
            instanceColor = UIColor(rgbValue: 0xffffff, alpha: 1.0)
            break

        case .textFieldPlaceholder:
            instanceColor = UIColor(rgbValue: 0x696969, alpha: 1.0)
            break

            // TODO: UIButton Color
        case .buttonPrimaryBG:
            instanceColor = UIColor(rgbValue: 0xECAE47, alpha: 1.0)
            break

        case .buttonSecondaryBG:
            instanceColor = UIColor(rgbValue: 0x4C4C4C, alpha: 1.0)
            break

        case .buttonPrimaryTitle:
            instanceColor = UIColor(rgbValue: 0xffffff, alpha: 1.0)
            break

        case .buttonSecondaryTitle:
            instanceColor = UIColor(rgbValue: 0xffffff, alpha: 1.0)
            break

        case .buttonBorder:
            instanceColor = UIColor(rgbValue: 0xffffff, alpha: 1.0)
            break

            // TODO: UILable Color
        case .labelText:
            instanceColor = UIColor(rgbValue: 0x000000, alpha: 1.0)
            break

        case .labelErrorText:
            instanceColor = UIColor(rgbValue: 0xffffff, alpha: 1.0)
            break

            // TODO: Segment View Color
        case .segmentBG:
            instanceColor = UIColor(rgbValue: 0x6648da, alpha: 1.0)
            break

        case .segmentTitle:
            instanceColor = UIColor(rgbValue: 0xffffff, alpha: 1.0)
            break

        case .segmentBorder:
            instanceColor = UIColor(rgbValue: 0xffffff, alpha: 1.0)
            break

        case .segmentSelectedBG:
            instanceColor = UIColor(rgbValue: 0x4C4C4C, alpha: 1.0)
            break

        case .segmentSelectedTitle:
            instanceColor = UIColor(rgbValue: 0xffffff, alpha: 1.0)
            break

            // TODO: Navigation Color
        case .navigationBG: // This will use for set navigation Text Color
            instanceColor = UIColor(rgbValue: 0xffffff, alpha: 1.0)
            break

        case .navigationTitle: // This will use for set navigation title color
            instanceColor = UIColor(rgbValue: 0x000000, alpha: 1.0)
            break

        case .navigationBottomBorder:
            instanceColor = UIColor(rgbValue: 0xffffff, alpha: 1.0)
            break

            // TODO: AlertView Color
        case .alertMessageText:
            instanceColor = UIColor(rgbValue: 0xffffff, alpha: 1.0)
            break

        case .alertErrorText:
            instanceColor = UIColor(rgbValue: 0xffffff, alpha: 1.0)
            break

        case .alertBG:
            instanceColor = UIColor(rgbValue: 0xffffff, alpha: 1.0)
            break

        case .alertErrorBG:
            instanceColor = UIColor(rgbValue: 0xffffff, alpha: 1.0)
            break

            // TODO: Custom Color
        case .custom(let hexValue, let opacity):
            instanceColor = UIColor(rgbValue: hexValue, alpha: CGFloat(opacity))
            break
        }
        return instanceColor
    }
}

public enum AppColor {

    // Activity loader
    case activityLoader
    case activityLoaderBG
    case activityText

    // Keyboard Bar Button Text Color
    case activeBarButtonText
    case disableBarButtonText
    case barButtonBorder

    case border
    case shadow

    // Application Background AppColor
    case appPrimaryBG
    case appSecondaryBG
    case appIntermidiateBG

    // Application Text Color
    case textFieldBG
    case textFieldText
    case textFieldPlaceholder
    case textFieldBorder
    case textFieldErrorBorder

    // Application UILabel Color
    case labelText
    case labelErrorText

    // Application Button Color
    case buttonPrimaryBG
    case buttonSecondaryBG
    case buttonPrimaryTitle
    case buttonSecondaryTitle
    case buttonBorder

    // Application SegmentView Color
    case segmentTitle
    case segmentBG
    case segmentSelectedTitle
    case segmentSelectedBG
    case segmentBorder

    // Application Navigation Color
    case navigationBG
    case navigationTitle
    case navigationBottomBorder

    // Application Murmor Alert Color
    case alertMessageText
    case alertErrorText
    case alertBG
    case alertErrorBG

    // 1
    case custom(hexString: Int, alpha: CGFloat)
    // 2
    public func withAlpha(_ alpha: CGFloat) -> UIColor {
        return self.value.withAlphaComponent(CGFloat(alpha))
    }
}

//For Font

//let system12            = Font(.system, size: .standard(.h5)).instance
//let robotoThin20        = Font(.installed(.RobotoThin), size: .standard(.h1)).instance
//let robotoBlack14       = Font(.installed(.OpenSansLight), size: .standard(.h4)).instance
//let helveticaLight13    = Font(.custom("Helvetica-Light"), size: .custom(13.0)).instance

struct Font {
    enum FontType {
        case installed(FontName)
        case custom(String)
        case system
        case systemBold
        case systemItatic
    }
    enum FontSize {
        case standard(StandardSize)
        case custom(Double)
        var value: Double {
            switch self {
            case .standard(let size):
                return size.rawValue
            case .custom(let customSize):
                return customSize
            }
        }
    }
    enum FontName: String {
        case AppleBold = "AppleSDGothicNeo-Bold"
        case Appleregular = "AppleSDGothicNeo-Regular"
        case AppleMedium = "AppleSDGothicNeo-Medium"
        case OpenSansLight = "OpenSans-Light"
        case RobotoItalic = "Roboto-Italic"
        case RobotoLight = "Roboto_Light"
        case RobotoLightItalic = "Roboto-LightItalic"
        case RobotoMedium = "Roboto-Medium"
        case RobotoMediumItalic = "Roboto-MediumItalic"
        case RobotoRegular = "Roboto-Regular"
        case RobotoThin = "Roboto-Thin"
        case RobotoThinItalic = "Roboto-ThinItalic"
    }
    enum StandardSize: Double {
        case h = 25.0
        case h1 = 20.0
        case h2 = 18.0
        case h3 = 16.0
        case h4 = 14.0
        case h5 = 12.0
        case h6 = 10.0

    }

    // 1
    var type: FontType
    var size: FontSize
    // 2
    init(_ type: FontType, size: FontSize) {
        self.type = type
        self.size = size
    }
}

class Utility {
    /// Logs all available fonts from iOS SDK and installed custom font
    class func logAllAvailableFonts() {
        for family in UIFont.familyNames {
            dLog("\(family)")
            for name in UIFont.fontNames(forFamilyName: family) {
                dLog("   \(name)")
            }
        }
    }
}

extension Font {
    var instance: UIFont {
        var instanceFont: UIFont!
        switch type {
        case .custom(let fontName):
            guard let font = UIFont(name: fontName, size: CGFloat(size.value)) else {
                fatalError("\(fontName) font is not installed, make sure it is added in Info.plist and logged with Utility.logAllAvailableFonts()")
            }
            instanceFont = font
        case .installed(let fontName):
            guard let font = UIFont(name: fontName.rawValue, size: CGFloat(size.value)) else {
                fatalError("\(fontName.rawValue) font is not installed, make sure it is added in Info.plist and logged with Utility.logAllAvailableFonts()")
            }
            instanceFont = font
        case .system:
            instanceFont = UIFont.systemFont(ofSize: CGFloat(size.value))
        case .systemBold:
            instanceFont = UIFont.boldSystemFont(ofSize: CGFloat(size.value))
        case .systemItatic:
            instanceFont = UIFont.italicSystemFont(ofSize: CGFloat(size.value))

        }
        return instanceFont
    }
}

