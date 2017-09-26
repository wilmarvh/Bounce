import Foundation

struct Localization {
    
    static let integerFormatter = NumberFormatter.integerFormatter()
    
    static let shortFullFormatter = DateFormatter.shortFullFormatter()
    
}

extension NumberFormatter {
    
    static func integerFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 0
        formatter.numberStyle = .decimal
        return formatter
    }
    
}

extension DateFormatter {
    
    static func shortFullFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        return formatter
    }
    
}
