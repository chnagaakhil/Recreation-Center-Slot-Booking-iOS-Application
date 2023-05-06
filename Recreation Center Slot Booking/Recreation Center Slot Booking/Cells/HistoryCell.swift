 

import UIKit

class HistoryCell: UITableViewCell {

    @IBOutlet weak var slot: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var courtId: UILabel!
    @IBOutlet weak var game: UILabel!
    
    
    func setData(booking:Booking) {
        
        self.slot.text = "Slot - \(booking.slot!)"
        self.date.text = "Booking Date - \(booking.date!)"
        self.courtId.text = "Court Id - \(booking.courtId!)"
        self.game.text = "Booked For - \(booking.game!)"
 
    }
    
}
