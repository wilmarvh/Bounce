import UIKit

class HooopsTabBarController: UITabBarController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        tabBar.clipsToBounds = true
        tabBar.isHidden = true
    }
    
}
