import Foundation
import CoreData
import UIKit

class DatabaseManager {
    
    static let databaseManager = DatabaseManager()
    
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Recreation_Center_Slot_Booking")
        container.loadPersistentStores { (_,_) in }
        return container
    }()
    
    
    func saveUser(_ user: User) {
        do {
            try container.viewContext.save()
        } catch {
            print("Error saving user: \(error.localizedDescription)")
        }
    }
    
    func cancelBooking(booking: Booking) {
        
        NotificationManager.shared.showNotification(message: "Booking cancelled")
        
        container.viewContext.delete(booking)
        
        do {
            try container.viewContext.save()
        } catch {
            print("Error cancelling booking: \(error)")
        }
    }


    
    func updateBooking(booking: Booking,newDate: String, newSlot: String)->Bool {
        
        let request: NSFetchRequest<Booking> = Booking.fetchRequest()
        request.predicate = NSPredicate(format: "date == %@ AND slot == %@ AND courtId == %@ AND game == %@", newDate, newSlot, booking.courtId!,booking.game!)
        
        do {
            let results = try container.viewContext.fetch(request)
            if let existingBooking = results.first {
                // Court is already booked by someone else
                showAlertAnyWhere(message: "Court \(booking.courtId!) is already booked on \(newDate) at \(newSlot) by \(existingBooking.userName ?? "")")
                
            } else {
                // Update the booking entity
            
                booking.date = newDate
                booking.slot = newSlot
                booking.timeStamp = Date().timeIntervalSince1970
                try container.viewContext.save()
                NotificationManager.shared.showNotification(message: "Booking for court \(booking.courtId!) on \(booking.date!) at \(booking.slot!) has been updated.")
                return true 
            }
        } catch {
            print("Error checking for existing bookings: \(error)")
        }
        
        return false
    }


    
    
    func bookCourt(name: String, email: String, game: String, date: String, slot: String, courtId: String) {
        let request: NSFetchRequest<Booking> = Booking.fetchRequest()
        request.predicate = NSPredicate(format: "date == %@ AND slot == %@ AND courtId == %@ AND game == %@", date, slot, courtId,game)
        
        do {
            let results = try container.viewContext.fetch(request)
            if let existingBooking = results.first {
                // Court is already booked
                showAlertAnyWhere(message: "Court \(courtId) is already booked on \(date) at \(slot) by \(existingBooking.userName ?? "")")
                
            } else {
                // Create a new booking entity
                let booking = Booking(context: container.viewContext)
                booking.userName = name
                booking.userEmail = email
                booking.game = game
                booking.date = date
                booking.slot = slot
                booking.courtId = courtId
                booking.timeStamp = Date().timeIntervalSince1970
               
                
                try container.viewContext.save()
                
                showAlertAnyWhere(message: "Court \(courtId) booked on \(date) at \(slot) by \(name)")
                
                
            }
        } catch {
            print("Error checking for existing bookings: \(error)")
        }
    }
    
    
    func getBookingsBySelection(game: String, date: String, slot: String) -> [Booking] {
        let context = container.viewContext
        let request: NSFetchRequest<Booking> = Booking.fetchRequest()
        
        // Set up the predicate to filter by game, date, and slot
        let predicate = NSPredicate(format: "game == %@ AND date == %@ AND slot == %@", game, date, slot)
        request.predicate = predicate
        
        // Fetch the matching bookings
        do {
            let results = try context.fetch(request)
            return results // Return an array of matching bookings
        } catch {
            print("Error fetching bookings: \(error)")
            return [] // Return an empty array if an error occurs
        }
    }
    
    func getMyAllBookings() -> [Booking] {
        let context = container.viewContext
        let request: NSFetchRequest<Booking> = Booking.fetchRequest()
       
        // Set up the predicate to filter by game, date, and slot
        let predicate = NSPredicate(format: "userEmail == %@",  UserDefaults.standard.string(forKey: "email")!)
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key: "timeStamp", ascending: false)]
       
        // Fetch the matching bookings
        do {
            let results = try context.fetch(request)
            return results // Return an array of matching bookings
        } catch {
            print("Error fetching bookings: \(error)")
            return [] // Return an empty array if an error occurs
        }
    }
    
    
    
    func setUser(email:String,firstName:String,lastName:String) {
        
        UserDefaults.standard.set(true, forKey: "loggedIn")
        UserDefaults.standard.set(email, forKey: "email")
        UserDefaults.standard.set(firstName + " " + lastName, forKey: "name")
    }
    
    func login(email: String, password: String) {
        let managedContext = container.viewContext
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "email == %@ AND password == %@", email, password)
        
        
        let users = try! managedContext.fetch(fetchRequest)
        if let user = users.first {
            print("User found")
            setUser(email: email, firstName: user.firstName!, lastName: user.lastName!)
            NotificationManager.shared.showNotification(message: "Welcome back \(user.firstName!) \( user.lastName!)")
            SceneDelegate.sceneDelegate?.setRootViewController()
        } else {
            showAlertAnyWhere(message: "Email Id or password do not match")
        }
    }
    
    
    func fetchUser() -> User? {
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "email == %@", UserDefaults.standard.string(forKey: "email")!)
        let managedContext = container.viewContext
        do {
            let users = try managedContext.fetch(fetchRequest)
            return users.first
        } catch {
            print("Error fetching user: \(error.localizedDescription)")
            return nil
        }
    }
    
    func fetchUserFromEmail(email:String) -> User? {
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        let managedContext = container.viewContext
        do {
            let users = try managedContext.fetch(fetchRequest)
            return users.first
        } catch {
            print("Error fetching user: \(error.localizedDescription)")
            return nil
        }
    }


    
    func createAccount(firstName:String, lastName:String, phone:String, email:String, password:String) {
        let managedContext = container.viewContext
        
        // Fetch the user with the given email address
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        
        do {
            let users = try managedContext.fetch(fetchRequest)
            if users.count > 0 {
                // User with the same email address already exists
                showAlertAnyWhere(message: "An account with this email address already exists.")
                return
            }
        } catch {
            print("Error fetching user: \(error)")
            return
        }

        
        // Create a new user entity and set its properties
        let userEntity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
        let user = User(entity: userEntity, insertInto: managedContext)
        user.firstName = firstName
        user.lastName = lastName
        user.phone = phone
        user.email = email
        user.password = password
        
        // Save the changes to the managed object context
        do {
            try managedContext.save()
            
            NotificationManager.shared.showNotification(message: "Welcome to the Recreation Center Slot Booking")
            
            showOkAlertAnyWhereWithCallBack(message: "Account registered successfully.") {
                
                self.setUser(email: email, firstName: firstName, lastName:lastName)
                
                SceneDelegate.sceneDelegate!.setRootViewController()
            }
            
        } catch {
            print("Error saving user: \(error)")
            return
        }
    }

    
    

}
 
        
 
