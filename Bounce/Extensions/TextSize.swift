import UIKit
import Foundation

public struct TextSize {
    
    fileprivate struct CacheEntry: Hashable {
        let text: String
        let font: UIFont
        let width: CGFloat
        let insets: UIEdgeInsets
        
        fileprivate var hashValue: Int {
            return text.hashValue ^ Int(width) ^ Int(insets.top) ^ Int(insets.left) ^ Int(insets.bottom) ^ Int(insets.right)
        }
    }
    
    fileprivate struct AttributedCacheEntry: Hashable {
        let attributedString: NSAttributedString
        let width: CGFloat
        let insets: UIEdgeInsets
        
        fileprivate var hashValue: Int {
            return attributedString.string.hashValue ^ Int(width) ^ Int(insets.top) ^ Int(insets.left) ^ Int(insets.bottom) ^ Int(insets.right)
        }
    }
    
    fileprivate static var cache = [CacheEntry: CGRect]() {
        didSet {
            assert(Thread.isMainThread)
        }
    }
    
    fileprivate static var attributedCache = [AttributedCacheEntry: CGRect]() {
        didSet {
            assert(Thread.isMainThread)
        }
    }
    
    public static func size(_ text: String, font: UIFont, width: CGFloat, insets: UIEdgeInsets = UIEdgeInsets.zero) -> CGRect {
        let key = CacheEntry(text: text, font: font, width: width, insets: insets)
        if let hit = cache[key] {
            return hit
        }
        
        let constrainedSize = CGSize(width: width - insets.left - insets.right, height: CGFloat.greatestFiniteMagnitude)
        let attributes = [ NSAttributedStringKey.font: font ]
        let options: NSStringDrawingOptions = [.usesFontLeading, .usesLineFragmentOrigin]
        var bounds = (text as NSString).boundingRect(with: constrainedSize, options: options, attributes: attributes, context: nil)
        bounds.size.width = width
        bounds.size.height = ceil(bounds.height + insets.top + insets.bottom)
        cache[key] = bounds
        return bounds
    }
    
    public static func size(_ text: String, font: UIFont, maxWidth: CGFloat, insets: UIEdgeInsets = UIEdgeInsets.zero) -> CGRect {
        let key = CacheEntry(text: text, font: font, width: maxWidth, insets: insets)
        if let hit = cache[key] {
            return hit
        }
        
        let constrainedSize = CGSize(width: maxWidth - insets.left - insets.right, height: CGFloat.greatestFiniteMagnitude)
        let attributes = [ NSAttributedStringKey.font: font ]
        let options: NSStringDrawingOptions = [.usesFontLeading, .usesLineFragmentOrigin]
        var bounds = (text as NSString).boundingRect(with: constrainedSize, options: options, attributes: attributes, context: nil)
        bounds.size.width = ceil(bounds.size.width)
        bounds.size.height = ceil(bounds.height + insets.top + insets.bottom)
        cache[key] = bounds
        return bounds
    }
    
    public static func size(_ attributedString: NSAttributedString, width: CGFloat, insets: UIEdgeInsets = UIEdgeInsets.zero) -> CGRect {
        let key = AttributedCacheEntry(attributedString: attributedString, width: width, insets: insets)
        if let hit = attributedCache[key] {
            return hit
        }
        
        let constrainedSize = CGSize(width: width - insets.left - insets.right, height: CGFloat.greatestFiniteMagnitude)
        let options: NSStringDrawingOptions = [.usesFontLeading, .usesLineFragmentOrigin]
        var bounds = attributedString.boundingRect(with: constrainedSize, options: options, context: nil)
        bounds.size.width = width
        bounds.size.height = ceil(bounds.height + insets.top + insets.bottom)
        attributedCache[key] = bounds
        return bounds
    }
}

private func == (lhs: TextSize.CacheEntry, rhs: TextSize.CacheEntry) -> Bool {
    return lhs.width == rhs.width && lhs.insets == rhs.insets && lhs.text == rhs.text
}

private func == (lhs: TextSize.AttributedCacheEntry, rhs: TextSize.AttributedCacheEntry) -> Bool {
    return lhs.width == rhs.width && lhs.insets == rhs.insets && lhs.attributedString.string == rhs.attributedString.string
}

