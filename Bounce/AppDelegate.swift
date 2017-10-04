import UIKit
import NothingButNet

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        if shortcutItem.type.contains("randomShot") {
            if let tabController = window?.rootViewController as? UITabBarController {
                tabController.selectedIndex = 0
                if let navCon = tabController.selectedViewController as? UINavigationController {
                    if let home = navCon.topViewController as? HomeViewController {
                        if home.shots.count > 0 {
                            let randomIndex = Int(arc4random_uniform(UInt32(home.shots.count)))
                            let shot = home.shots[randomIndex]
                            home.performSegue(withIdentifier: "showShotDetail", sender: shot)
                        } else {
                            home.loadData(completion: {
                                let randomIndex = Int(arc4random_uniform(UInt32(home.shots.count)))
                                let shot = home.shots[randomIndex]
                                home.performSegue(withIdentifier: "showShotDetail", sender: shot)
                            })
                        }
                    }
                }
            }
        }
    }

}

