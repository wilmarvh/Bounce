import UIKit

extension UIColor {
    
    static func bounceBlack() -> UIColor {
        return UIColor(red:0.20000, green:0.20000, blue:0.20000, alpha:1.00000)
    }
    
    static func mediumPink() -> UIColor {
        return UIColor(red:0.96471, green:0.25490, blue:0.54118, alpha:1.00000)
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
