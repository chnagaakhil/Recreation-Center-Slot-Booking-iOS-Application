
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    static var sceneDelegate: SceneDelegate?
    var window: UIWindow?
   
    func setRootViewController() {
        let isLoggedIn = UserDefaults.standard.bool(forKey: "loggedIn")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if isLoggedIn {
            
            let postLogin = UserDefaults.standard.bool(forKey: "postLogin")
            
            if(postLogin) {
                let homeVC = storyboard.instantiateViewController(withIdentifier: "TabBarHome")
                window!.rootViewController = homeVC
            }else {
                UserDefaults.standard.set(true, forKey: "postLogin")
                let homeVC = storyboard.instantiateViewController(withIdentifier: "PreHomeVC")
                window!.rootViewController = homeVC
            }
            
          
        } else {
             
            let loginVC = storyboard.instantiateViewController(withIdentifier: "NavigationHome")
            window!.rootViewController = loginVC
        }
    }

  
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Don't call setRootViewController here
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        SceneDelegate.sceneDelegate = self
        guard let window = window else { return }
        SceneDelegate.sceneDelegate = self
        setRootViewController()
        window.makeKeyAndVisible()
    }
}



