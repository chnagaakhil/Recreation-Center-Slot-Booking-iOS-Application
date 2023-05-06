 
import UIKit

class BookedVC: UIViewController {

    @IBOutlet weak var containerView: UIStackView!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var slot: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var courtId: UILabel!
    @IBOutlet weak var game: UILabel!
    
    override func viewDidLoad() {
        containerView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        self.tabBarController?.tabBar.isHidden = false
  
        
       let bookings = DatabaseManager.databaseManager.getMyAllBookings()
        
        if(!bookings.isEmpty) {
            self.containerView.isHidden = false
            self.setData(booking: bookings.first!)
        }else {
            self.containerView.isHidden = true
        }
        
    }
    
    func setData(booking:Booking) {
        
        self.gameTitle.text = booking.game!  + " Court Booked"
        self.slot.text = "Slot - \(booking.slot!)"
        self.date.text = "Booking Date - \(booking.date!)"
        self.courtId.text = "Court Id - \(booking.courtId!)"
        self.game.text = "Booked For - \(booking.game!)"
        
        self.setImage(game: booking.game!)
 
    }
    
    
    func setImage(game:String) {
        
        if(game.lowercased().contains("basketball")) {
            self.gameImage.image = UIImage(named: "BasketBall")
        }
        
        if(game.lowercased().contains("volleyball")) {
            self.gameImage.image = UIImage(named: "Volleyball")
        }
        
        if(game.lowercased().contains("badminton")) {
            self.gameImage.image = UIImage(named: "Badminton")
        }
        
        if(game.lowercased().contains("tennis")) {
            
            self.gameImage.image = UIImage(named: "Tennis")
        }
        if(game.lowercased().contains("racquetball")) {
            self.gameImage.image = UIImage(named: "Racquetball")
        }
    }
    
    @IBAction func onBookingButtonClick(_ sender: Any) {
        
        let vc = self .storyboard?.instantiateViewController(withIdentifier: "BookingVC") as! BookingVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)

    }
    
    
}
