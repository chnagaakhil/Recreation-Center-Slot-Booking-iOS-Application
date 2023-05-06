 
import UIKit

class PreHomeVC: UIViewController {
    
    @IBAction func onGetStarted(_ sender: Any) {
        
        let vc = self .storyboard?.instantiateViewController(withIdentifier: "WelcomeVC")
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true)
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(11)) {
            
          SceneDelegate.sceneDelegate!.setRootViewController()
            
        }
       
    }
}
