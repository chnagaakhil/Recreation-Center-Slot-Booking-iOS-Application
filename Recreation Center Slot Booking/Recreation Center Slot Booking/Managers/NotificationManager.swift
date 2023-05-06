 
import UIKit
import UserNotifications

 
class NotificationManager  {
    
    static let shared = NotificationManager()
    private let notificationCenter = UNUserNotificationCenter.current()

    func setPermition() {
        
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification authorization: \(error.localizedDescription)")
            }
        }
    }

    
    func showNotification(message: String) {
        
       
        
        let content = UNMutableNotificationContent()
        content.title = message
        content.body = message
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        let request = UNNotificationRequest(identifier: "local_notification", content: content, trigger: trigger)

        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error showing notification: \(error.localizedDescription)")
            }
        }
    }
}
