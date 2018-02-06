import UIKit

class HooopsTabBarItem: UITabBarItem {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let inset: CGFloat = 5
        imageInsets = UIEdgeInsets(top: inset, left: 0, bottom: -inset, right: 0)
    }
    
}
