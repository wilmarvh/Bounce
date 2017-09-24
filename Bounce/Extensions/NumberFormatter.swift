import Foundation

struct Localization {
    
    static let integerFormatter = NumberFormatter.integerFormatter()
    
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
