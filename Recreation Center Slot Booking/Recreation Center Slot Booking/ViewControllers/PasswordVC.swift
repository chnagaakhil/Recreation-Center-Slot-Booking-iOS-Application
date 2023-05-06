 
import UIKit

class PasswordVC: UIViewController {

    @IBOutlet weak var currentPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!

    @IBAction func onSave(_ sender: Any) {
        guard let user = DatabaseManager.databaseManager.fetchUser() else {
            // handle error: user not found
            return
        }
        
        guard let currentPassword = currentPassword.text, !currentPassword.isEmpty else {
            showAlert(title: "Error", message: "Please enter your current password.")
            return
        }
        
        guard let newPassword = newPassword.text, !newPassword.isEmpty else {
            showAlert(title: "Error", message: "Please enter a new password.")
            return
        }
        
        guard let confirmPassword = confirmPassword.text, !confirmPassword.isEmpty else {
            showAlert(title: "Error", message: "Please confirm your new password.")
            return
        }
        
        if currentPassword != user.password {
            showAlert(title: "Error", message: "The current password you entered is incorrect.")
            return
        }
        
        if newPassword != confirmPassword {
            showAlert(title: "Error", message: "The new passwords you entered do not match.")
            return
        }
        
        // save new password
        user.password = newPassword
        DatabaseManager.databaseManager.saveUser(user)
        
        showOkAlertAnyWhereWithCallBack(message: "Your password has been updated." ) {
            profileVC.fetchData()
            self.dismiss(animated: true)
        }
        
    }
    @IBAction func onBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
