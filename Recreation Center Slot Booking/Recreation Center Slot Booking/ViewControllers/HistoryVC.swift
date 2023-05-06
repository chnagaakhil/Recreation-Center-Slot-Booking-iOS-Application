 
import UIKit

class HistoryVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var myAllBookings = [Booking]()
    
    override func viewDidLoad() {
        
        self.tableView.registerCells([HistoryCell.self])
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        myAllBookings =  DatabaseManager.databaseManager.getMyAllBookings()
        
        self.tableView.reloadData()
    }

}



extension HistoryVC: UITableViewDelegate, UITableViewDataSource {
   
  
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
       return myAllBookings.count
   }
   
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let cell = self.tableView.dequeueReusableCell(withIdentifier: "HistoryCell") as! HistoryCell
       cell.setData(booking: myAllBookings[indexPath.row])
       return cell
       
   }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
        let booking = myAllBookings[indexPath.row]
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UpdateBookingVC") as! UpdateBookingVC
        vc.modalPresentationStyle = .fullScreen
        vc.booking = booking
        self.present(vc, animated: true)
    }
  
  
}
