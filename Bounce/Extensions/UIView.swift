import UIKit

extension UIView {
    
    func addDefaultShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.2
    }
    
    func addSmallShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.2
    }
    
}

extension CALayer {
    
    public func removeAllBorderLayers() {
        if let borderLayers = self.sublayers?.filter({ $0 is BorderLayer || $0 is BottomBorderLayer }) {
            borderLayers.forEach({ $0.removeFromSuperlayer() })
        }
    }
    
    public func addBorder(edge: UIRectEdge, color: UIColor = UIColor.lightGray, thickness: CGFloat = (1 / UIScreen.main.scale)) {
        
        let border = BorderLayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor
        
        self.addSublayer(border)
    }
    
    public func addBottomBorder(inset: CGFloat) {
        let line = BottomBorderLayer()
        let linePath = UIBezierPath()
        let lineWidth = 1 / UIScreen.main.scale
        let start = CGPoint(x: self.frame.origin.x + inset, y: self.frame.size.height)
        let end = CGPoint(x: self.frame.width, y: self.frame.size.height)
        linePath.move(to: start)
        linePath.addLine(to: end)
        line.path = linePath.cgPath
        line.fillColor = nil
        line.opacity = 1.0
        line.strokeColor = UIColor.lightGray.cgColor
        line.lineWidth = lineWidth
        self.addSublayer(line)
    }
    
    public func addTopBorder(inset: CGFloat) {
        let line = TopBorderLayer()
        let linePath = UIBezierPath()
        let lineWidth = 1 / UIScreen.main.scale
        let start = CGPoint(x: self.frame.origin.x + inset, y: self.frame.origin.y)
        let end = CGPoint(x: self.frame.width, y: self.frame.origin.y)
        linePath.move(to: start)
        linePath.addLine(to: end)
        line.path = linePath.cgPath
        line.fillColor = nil
        line.opacity = 1.0
        line.strokeColor = UIColor.lightGray.cgColor
        line.lineWidth = lineWidth
        self.addSublayer(line)
    }
}

class BorderLayer: CALayer {
}

class BottomBorderLayer: CAShapeLayer {
}

class TopBorderLayer: CAShapeLayer {
}

