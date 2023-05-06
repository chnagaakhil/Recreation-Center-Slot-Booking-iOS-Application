 

import UIKit

class NameEditVC: UIViewController {

    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    
    override func viewDidLoad() {
         
        guard let user = DatabaseManager.databaseManager.fetchUser() else {
            // handle error: user not found
            return
        }
        
        self.firstName.text = user.firstName!
        self.lastName.text = user.lastName!
    }

    @IBAction func onBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func onSave(_ sender: Any) {
        
        guard let user = DatabaseManager.databaseManager.fetchUser() else {
            // handle error: user not found
            return
        }
        
        if self.firstName.text!.count < 1 {
                   showAlert(title: "Error", message: "Please enter first name")
                   return
        }
        
        if self.lastName.text!.count < 1 {
                   showAlert(title: "Error", message: "Please enter last name")
                   return
        }
        
              user.firstName = self.firstName.text!
              user.lastName = self.lastName.text!
              DatabaseManager.databaseManager.saveUser(user)
            
        showOkAlertAnyWhereWithCallBack(message: "Your name has been updated." ) {
                   profileVC.fetchData()
                   self.dismiss(animated: true)
            }
        
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
