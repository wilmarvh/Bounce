import Foundation

protocol NewLineChopable {
    
    func trailingNewlineChopped() -> NSMutableAttributedString
    
}

extension NSMutableAttributedString: NewLineChopable {
    
    func trailingNewlineChopped() -> NSMutableAttributedString {
        if string.hasSuffix("\n") {
            return NSMutableAttributedString(attributedString: self.attributedSubstring(from: NSMakeRange(0, self.length - 1)))
        } else {
            return self
        }
    }
    
}
