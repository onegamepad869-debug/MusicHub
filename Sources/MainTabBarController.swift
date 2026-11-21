import UIKit

final class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        viewControllers = MusicService.all.map { WebViewController(service: $0) }
    }

    // Tapping the tab you are already on goes back to that service's start page.
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController === selectedViewController, let web = viewController as? WebViewController {
            web.goHome()
        }
        return true
    }
}
