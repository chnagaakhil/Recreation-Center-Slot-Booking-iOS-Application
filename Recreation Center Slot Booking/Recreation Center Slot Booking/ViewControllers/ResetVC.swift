 

import UIKit

class ResetVC: UIViewController {

   
    @IBOutlet weak var email: UITextField!
    
    @IBAction func onLogin(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onSendEmail(_ sender: Any) {
        
    }
    
}
