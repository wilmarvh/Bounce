import UIKit

class HoopsTabBarController: UITabBarController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        tabBar.clipsToBounds = true
        tabBar.isHidden = true
    }
    
}
