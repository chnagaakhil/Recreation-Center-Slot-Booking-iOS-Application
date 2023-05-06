import UIKit


class CreateAccountVC: UIViewController ,UITextFieldDelegate {
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.phone.isUserInteractionEnabled = false
        
        email.delegate = self
        phone.delegate = self
        // Add a target-action for the EditingChanged control event of the email text field
               email.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
      }
    
    func enableDisablePhoneField() {
        
        if(nwmissouriUsers.contains(self.email.text!)) {
            self.phone.isUserInteractionEnabled = true
        }else {
            self.phone.isUserInteractionEnabled = false
            self.phone.text = ""
        }
        
    }
    @objc func emailChanged() {
          enableDisablePhoneField()
    }
    
    
    
    // UITextFieldDelegate method
       func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
          
           if textField == phone {
                       // Get the new text that would result from adding the replacement string to the current text
                       let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
                       // Limit the length of the phone number field to 6 digits
                       return newText.count <= 6
          }
           
           return true
       }
    
    
    @IBAction func signupButtonClicked(_ sender: Any) {
        
        
        if(self.firstName.text!.isEmpty || self.lastName.text!.isEmpty) {
             showAlertAnyWhere(message: "Please enter first Name and last Name.")
             return
        }
        
        if (email.text!.isEmpty){
            showAlertAnyWhere(message: "Please enter email")
            return
        }
        
        
        if !mailIsCorrectFormate(email: email.text!) {
            showAlertAnyWhere(message: "Please enter valid email id")
            return
        }
        
       
        if(self.password.text!.isEmpty) {
             showAlertAnyWhere(message: "Please enter password.")
             return
        }
        
        if(nwmissouriUsers.contains(self.email.text!)) {
            
            if(self.phone.text!.count < 6) {
                showAlertAnyWhere(message: "Please complete your 919# number.")
                return
            }
        }
        
        if(!nwmissouriUsers.contains(self.email.text!)) {
            self.phone.text = ""
        }
        DatabaseManager.databaseManager.createAccount(firstName:firstName.text!,lastName:lastName.text!,phone:phone.text!,email:email.text!,password:password.text!)
        
    }
    
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
   
    
    
    func mailIsCorrectFormate(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
}
    
 


 
