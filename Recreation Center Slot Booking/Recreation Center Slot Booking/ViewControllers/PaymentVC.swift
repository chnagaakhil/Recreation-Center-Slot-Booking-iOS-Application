import UIKit


class PaymentVC: UIViewController  {
    
   
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var tinyCreditCardView: TinyCreditCardView!
    var onSuccess: (() -> Void)?
      
    @IBOutlet weak var totalPrice: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = DatabaseManager.databaseManager.fetchUser()
        self.payButton.isHidden = true
        tinyCreditCardView.cardHolderInputView.backgroundColor = UIColor.black
        
        tinyCreditCardView.cardHolderInputView.textField.text =  user!.firstName! + " " +  user!.lastName!
        
        tinyCreditCardView.cscNumberInputView.didTapNextButton = {
          
            self.payButton.isHidden = false
 
        }
        
        if(isNwmissouriUser()) {
            self.totalPrice.text = "Total Amount - 0$"
        }else {
            self.totalPrice.text = "Total Amount - 20$"
        }
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func onPay(_ sender: Any) {
       
        self.payButton.isHidden = true
        
       
        let tempView = UIView(frame: .infinite)
        tempView.backgroundColor = UIColor.white
        self.view.addSubview(tempView)
        
        guard let confettiImageView = UIImageView.fromGif(frame: view.frame, resourceName: "wait") else { return }
        confettiImageView.contentMode = .scaleAspectFit
        view.addSubview(confettiImageView)
      
        confettiImageView.startAnimating()
        
    
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(4)) {
            
            confettiImageView.removeFromSuperview()
            guard let confettiImageView = UIImageView.fromGif(frame: self.view.frame, resourceName: "success") else { return }
            confettiImageView.contentMode = .scaleAspectFit
            self.view.addSubview(confettiImageView)
            self.view.backgroundColor  = .white
            confettiImageView.startAnimating()
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(5)) {
                
                
                self.dismiss(animated: true) {
                   
                    self.onSuccess?()
                }
            
            }
            
        }
        
        
    
        
        
       
        
        
    }
}

 
