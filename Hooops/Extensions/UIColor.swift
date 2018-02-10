import UIKit

extension UIColor {
    
    static func hooopsGreen() -> UIColor {
        return UIColor(red:0/200, green:200/255.0, blue:158/255.0, alpha:1.00000)
    }
    
    static func darkBlueGrey() -> UIColor {
        return UIColor(red:28/200, green:41/255.0, blue:74/255.0, alpha:1.00000)
    }
    
    static func grayButton() -> UIColor {
        return UIColor(red:239/255.0, green:239/255.0, blue:244/255.0, alpha:1.00000)
    }
    
    // MARK: Utilities
    
    func rgb() -> (red: Int, green: Int, blue: Int, alpha: Int)? {
        var fRed: CGFloat = 0
        var fGreen: CGFloat = 0
        var fBlue: CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            let iAlpha = Int(fAlpha * 255.0)
            
            return (red:iRed, green:iGreen, blue:iBlue, alpha:iAlpha)
        } else {
            // Could not extract RGBA components:
            return nil
        }
    }
    
}
