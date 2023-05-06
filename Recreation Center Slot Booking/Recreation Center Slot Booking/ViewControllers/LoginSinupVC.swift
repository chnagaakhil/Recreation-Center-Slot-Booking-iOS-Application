 
import UIKit

class LoginSinupVC: UIViewController {

    @IBOutlet weak var singupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginButton.layer.borderWidth = 2
        self.loginButton.layer.cornerRadius = 15
        
        self.singupButton.layer.borderWidth = 2
        self.singupButton.layer.cornerRadius = 15
        
        self.loginButton.layer.borderColor = UIColor.black.cgColor
        self.singupButton.layer.borderColor = UIColor.black.cgColor
    }


}

