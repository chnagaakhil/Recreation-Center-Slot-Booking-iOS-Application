 
import UIKit
import LocalAuthentication

class LoginVC: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 15
        
    }
    
    @IBAction func onLogin(_ sender: Any) {
        
        if(email.text!.isEmpty) {
             showAlertAnyWhere(message: "Please enter email.")
            return
        }

        if(self.password.text!.isEmpty) {
             showAlertAnyWhere(message: "Please enter password.")
             return
        }

        DatabaseManager.databaseManager.login(email: email.text!, password: self.password.text!)
        let context = LAContext()
             var error : NSError?
             let reason = "Login and FaceID for Security "
             if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
                 
                 context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason){success , evaluateerror in
                     if success{
                         DispatchQueue.main.async {
                             self.performSegue(withIdentifier: "login", sender: self)
                         }
                     }
                     else{
                         DispatchQueue.main.async {
                             let alert = UIAlertController(title: "Error", message: "FaceID authentication failed", preferredStyle: .alert)
                             let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
                             alert.addAction(OK)
                             self.present(alert, animated: true, completion: nil)
                         }
                             
                         }
                     }
                     
                 }
                 else{
                     let alertController = UIAlertController(title: "Error", message: "FaceID not available on this device", preferredStyle: .alert)
                     let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
                     alertController.addAction(OK)
                     self.present(alertController, animated: true, completion: nil)
                 }
    }

    @IBAction func forgotPassClick(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Enter Email", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Email"
        }
        let sendAction = UIAlertAction(title: "Send", style: .default) { [weak self] _ in
            guard let email = alertController.textFields?.first?.text, !email.isEmpty else {
               showAlertAnyWhere(message: "Email is required")
                return
            }
            let user = DatabaseManager.databaseManager.fetchUserFromEmail(email: email)
            guard let password = user?.password else {
                showAlertAnyWhere(message: "Email Not Found")
                return
            }
            
            let body = "<H1> Your password is \(password) </H1>"
            
            // Show a loading spinner
            let loadingIndicator = UIActivityIndicatorView()
            loadingIndicator.style = .medium
            loadingIndicator.center =  self?.view.center ?? .zero
            self?.view.addSubview(loadingIndicator)
            loadingIndicator.startAnimating()

            // Call the sendEmail function and handle its response
            ForgetPasswordManager.sendEmail(emailTo: email, body: body) { success in
                DispatchQueue.main.async {
                    loadingIndicator.stopAnimating()
                    if success {
                       showAlertAnyWhere(message: "Please check your email box for password")
                    } else {
                         showAlertAnyWhere(message: "Error sending email")
                    }
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(sendAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }


    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}




 
