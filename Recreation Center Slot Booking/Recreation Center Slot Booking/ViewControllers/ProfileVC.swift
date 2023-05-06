 
import UIKit

var profileVC : ProfileVC!
 
class ProfileVC: UIViewController {

    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var email: UITextField!

    override func viewDidLoad() {
        profileVC = self
    }
  
  
    override func viewWillAppear(_ animated: Bool) {
        self.fetchData()
    }
    func fetchData() {
        
        if let user =  DatabaseManager.databaseManager.fetchUser() {
                     self.firstName.text = "First Name : \(user.firstName!)"
                     self.lastName.text = "Last Name : \(user.lastName!)"
                    
                     self.email.text = "Email : \(user.email!)"
                 
                 if(user.phone!.isEmpty) {
                     self.phone.text = "Your 919# : NA"
                 }else {
                     self.phone.text = "Your : #919\(user.phone!)"
                 }
                 
        }
        
    }
    
    @IBAction func onLogotClicked(_ sender: Any) {
        
     
        showConfirmationAlert(message: "Are you sure want to logout?") { _ in
            
            let defaults = UserDefaults.standard
            let dictionary = defaults.dictionaryRepresentation()
            dictionary.keys.forEach{key in   defaults.removeObject(forKey: key)} // Clear User Defaults
            
            SceneDelegate.sceneDelegate?.setRootViewController()
        }
       
    }
}
