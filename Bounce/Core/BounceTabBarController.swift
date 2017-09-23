import UIKit

class BounceTabBarController: UITabBarController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        tabBar.tintColor = UIColor.mediumPink()
        tabBar.clipsToBounds = true
    }
    
}
