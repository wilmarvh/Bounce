import UIKit

extension UIFont {    
    static let title1Descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFontTextStyle.title1)
    static let title2Descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFontTextStyle.title2)
    static let title3Descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFontTextStyle.title3)
    static let headlineDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFontTextStyle.headline)
    static let bodyDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFontTextStyle.body)
    static let subheadlineDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFontTextStyle.subheadline)
    static let footnoteDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFontTextStyle.footnote)
}

extension UIFont {
    
    class func title1Font() -> UIFont {
        return UIFont.systemFont(ofSize: title1Descriptor.pointSize, weight: UIFont.Weight.heavy)
    }
    
    class func title2Font() -> UIFont {
        return UIFont.systemFont(ofSize: title2Descriptor.pointSize, weight: UIFont.Weight.heavy)
    }
    
    class func title3Font() -> UIFont {
        return UIFont.systemFont(ofSize: title3Descriptor.pointSize, weight: UIFont.Weight.heavy)
    }
    
    class func headlineFont() -> UIFont {
        return UIFont.systemFont(ofSize: headlineDescriptor.pointSize, weight: UIFont.Weight.semibold)
    }
    
    class func bodyFont() -> UIFont {
        return UIFont.systemFont(ofSize: bodyDescriptor.pointSize, weight: UIFont.Weight.regular)
    }
    
    class func subheadlineFont() -> UIFont {
        return UIFont.systemFont(ofSize: subheadlineDescriptor.pointSize, weight: UIFont.Weight.regular)
    }
    
    class func footnoteFont() -> UIFont {
        return UIFont.systemFont(ofSize: footnoteDescriptor.pointSize, weight: UIFont.Weight.regular)
    }
}
