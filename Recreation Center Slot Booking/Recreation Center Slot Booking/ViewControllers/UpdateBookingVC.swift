import UIKit
import CoreData

class UpdateBookingVC: UIViewController {
    
    var booking : Booking!
    var timeSlots: [String] = []
   
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var timeSlotButton: UIButton!
    
    @IBOutlet weak var slot: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var courtId: UILabel!
    @IBOutlet weak var game: UILabel!
    
    var selectedDate = ""
    var selectedTimeSlot = ""
   
    
    override func viewDidLoad() {
        self.timeSlots = getTimeSlots()
        self.tabBarController?.tabBar.isHidden = true
        setData(booking: booking)
    }
    
    func setData(booking:Booking) {
        
        self.slot.text = "Slot - \(booking.slot!)"
        self.date.text = "Booking Date - \(booking.date!)"
        self.courtId.text = "Court Id - \(booking.courtId!)"
        self.game.text = "Booked For - \(booking.game!)"
        
    }
   
   
   
    @IBAction func onBack(_ sender: Any) {
        
        self.dismiss(animated: true)
    }
    
    @IBAction func onDate(_ sender: Any) {
        
       
        let picker = DatePicker()
        picker.modalPresentationStyle = .overCurrentContext
        
        picker.onDone = { date in
            self.selectedDate = date
            self.dateButton.setTitle(date, for: .normal)
            self.timeSlotButton.setTitle("Select Time Slot", for: .normal)
            self.selectedTimeSlot = ""
        }
       
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func onTimeSlot(_ sender: Any) {
        
        if(selectedDate.isEmpty) {
            showAlertAnyWhere(message: "Please select date or game type first ")
            return
        }
        
        
        let picker = ArrayItemPicker()
        picker.stringArray = timeSlots
        picker.modalPresentationStyle = .overCurrentContext
        picker.onDone = { index in
            self.selectedTimeSlot = self.timeSlots[index]
            self.timeSlotButton.setTitle( self.selectedTimeSlot, for: .normal)
            
        }
        present(picker, animated: true, completion: nil)
        
    }
    
     
    @IBAction func onDelete(_ sender: Any) {
        
        showConfirmationAlert(message: "Are you sure want to cancel this booking?") { _ in
            DatabaseManager.databaseManager.cancelBooking(booking: self.booking)
            self.dismiss(animated: true)
        }
    }
    
    
    @IBAction func onUpdate(_ sender: Any) {
        
       
        if(self.selectedDate.isEmpty || self.selectedTimeSlot.isEmpty) {
            showAlertAnyWhere(message: "Please add all details")
            return
        }
      
      let result =  DatabaseManager.databaseManager.updateBooking(booking: self.booking, newDate: selectedDate, newSlot: selectedTimeSlot)
        
        if(result == true ) {
            self.dismiss(animated: true)
        }
      
    }
    
    
}


 

