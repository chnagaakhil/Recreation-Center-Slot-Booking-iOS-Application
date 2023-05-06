 
import UIKit
import CoreData

class BookingVC: UIViewController {
    
    var bookings: [Booking] = []
    var timeSlots: [String] = []
    
    var selectedPosition: Int = -1
    
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var gameTypeButton: UIButton!
    @IBOutlet weak var timeSlotButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedGame = ""
    var selectedDate = ""
    var selectedTimeSlot = ""
    var selectedCourt = ""
    
    
    override func viewDidLoad() {
        self.timeSlots = getTimeSlots()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.registerCells([CourtCell.self])
        self.tabBarController?.tabBar.isHidden = true
    }
   
   
    @IBAction func onGameType(_ sender: Any) {
        
        let picker = ArrayItemPicker()
        picker.stringArray = gamesArray
        picker.modalPresentationStyle = .overCurrentContext
        picker.onDone = { index in
            self.selectedGame = gamesArray[index]
            self.gameTypeButton.setTitle( self.selectedGame, for: .normal)
            self.dateButton.setTitle("Select Date", for: .normal)
            self.selectedDate = ""
            self.timeSlotButton.setTitle("Select Time Slot", for: .normal)
            self.selectedTimeSlot = ""
            self.reloadCollectionView()
        }
        present(picker, animated: true, completion: nil)
        
    }
    
   
    
    @IBAction func onBack(_ sender: Any) {
        
        self.dismiss(animated: true)
    }
    @IBAction func onDate(_ sender: Any) {
        
        if(selectedGame.isEmpty) {
            showAlertAnyWhere(message: "Please select your game first")
            return
        }
        
        let picker = DatePicker()
        picker.modalPresentationStyle = .overCurrentContext
        
        picker.onDone = { date in
            self.selectedDate = date
            self.dateButton.setTitle(date, for: .normal)
            self.timeSlotButton.setTitle("Select Time Slot", for: .normal)
            self.selectedTimeSlot = ""
            self.reloadCollectionView()
        }
       
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func onTimeSlot(_ sender: Any) {
        
        if(selectedDate.isEmpty || selectedGame.isEmpty) {
            showAlertAnyWhere(message: "Please select date or game type first ")
            return
        }
        
        
        let picker = ArrayItemPicker()
        picker.stringArray = timeSlots
        picker.modalPresentationStyle = .overCurrentContext
        picker.onDone = { index in
            self.selectedTimeSlot = self.timeSlots[index]
            self.timeSlotButton.setTitle( self.selectedTimeSlot, for: .normal)
            self.reloadCollectionView()
        }
        present(picker, animated: true, completion: nil)
        
    }
    
    func reloadCollectionView() {
        
        self.selectedPosition = -1
        self.selectedCourt = ""

        if(selectedTimeSlot.isEmpty || selectedDate.isEmpty || selectedGame.isEmpty) {
            self.collectionView.isHidden = true
        }else {
            self.collectionView.isHidden = false
            
            self.bookings = DatabaseManager.databaseManager.getBookingsBySelection(game: self.selectedGame, date: self.selectedDate, slot: self.selectedTimeSlot)
            self.collectionView.reloadData()
             
        }
    }
    
}




extension BookingVC: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return courtsDict[selectedGame]?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let cellWidth = collectionView.frame.size.width / 2 - 10 // 2 cells per row with 10 spacing between cells
            return CGSize(width: cellWidth, height: cellWidth)
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CourtCell", for: indexPath) as! CourtCell
            
        let text = selectedGame + "\nCourt\n" +  courtsDict[selectedGame]![indexPath.row]
        
        cell.titleLabel.text = text
        
       
        
        if(selectedPosition == indexPath.row) {
            cell.layer.borderWidth = 2
            cell.layer.borderColor = UIColor.green.cgColor
        }else {
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.gray.cgColor
        }
        cell.layer.cornerRadius = 5
        
      
        if(isAlreadyBooked(row: indexPath.row)) {
            cell.backgroundColor = .lightGray
            cell.titleLabel.textColor = .red
        }else {
            cell.backgroundColor = .clear
            cell.titleLabel.textColor = .black
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let isAlreadyBooked = self.isAlreadyBooked(row: indexPath.row)
        
        if(isAlreadyBooked) {
            showAlertAnyWhere(message: "This Court is Already Booked")
            return
        }
        
        self.selectedCourt = courtsDict[selectedGame]![indexPath.row]
        selectedPosition = indexPath.row
        self.collectionView.reloadData()
    }
    
    func isAlreadyBooked(row:Int)->Bool {
        let courtId = courtsDict[selectedGame]![row]
        let courtBookings = self.bookings.map { $0.courtId == courtId }
        let courtIsBooked = courtBookings.contains(true)

        return courtIsBooked
    }
    
    @IBAction func onBookNow(_ sender: Any) {
        
        if(selectedPosition  == -1) {
            showAlertAnyWhere(message: "Please select court")
            return
        }
        
        if(self.selectedGame.isEmpty || self.selectedDate.isEmpty || self.selectedTimeSlot.isEmpty || self.selectedCourt.isEmpty) {
            showAlertAnyWhere(message: "Please add all details")
            return
        }
       
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
        vc.modalPresentationStyle = .fullScreen
        
        vc.onSuccess = {
            print("Payment successful")
            self.afterPaymentSaveInCoreData()
        }
        
        self.present(vc, animated: true)
        
      
       
    }
    
    func afterPaymentSaveInCoreData() {
        
        
        let name =  UserDefaults.standard.string(forKey: "name")!
        let email = UserDefaults.standard.string(forKey: "email")!
        
        let user = DatabaseManager.databaseManager.fetchUser()
         
        let message = "\(user!.firstName!)  \(user!.lastName!) You have successfully booked the court \( self.selectedCourt) for the game \(self.selectedGame) on \(self.selectedDate) \(self.selectedTimeSlot) "
        NotificationManager.shared.showNotification(message: message)
       
        DatabaseManager.databaseManager.bookCourt(name: name, email: email, game: self.selectedGame, date: self.selectedDate, slot: self.selectedTimeSlot, courtId: self.selectedCourt)
      
        let calanderMsg = message
        
        CalendarManager.shared.createEvent(title: calanderMsg, date: self.selectedDate, fromTo: self.selectedTimeSlot)
        
        
        self.reloadCollectionView()
    }
}




