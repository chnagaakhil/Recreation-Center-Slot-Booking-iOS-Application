import UIKit

var otherUserTimeSlots = ["09:00 AM - 11:00 AM", "10:00 AM - 12:00 PM", "11:00 AM - 01:00 PM", "12:00 PM - 02:00 PM", "01:00 PM - 03:00 PM", "02:00 PM - 04:00 PM", "03:00 PM - 05:00 PM", "04:00 PM - 06:00 PM", "05:00 AM - 07:00 AM", "06:00 AM - 08:00 AM", "07:00 AM - 09:00 PM"]

var nwmissouriUsersTimeSlots = ["09:00 AM - 01:00 PM","10:00 AM - 02:00 PM", "11:00 AM - 03:00 PM", "12:00 PM - 04:00 PM", "01:00 PM - 05:00 PM", "02:00 PM - 06:00 PM", "03:00 PM - 07:00 PM","04:00 PM - 08:00 PM", "05:00 PM - 09:00 PM"];

func getTimeSlots()->[String] {
    
    if(isNwmissouriUser()) {
        return nwmissouriUsersTimeSlots
    }else {
        return otherUserTimeSlots
    }
    
}


func isNwmissouriUser()->Bool{
    
   let email = UserDefaults.standard.string(forKey: "email")!
    
    if(nwmissouriUsers.contains(email)) {
        return true
    }else {
        return false
    }
    
}



let gamesArray: [String] = ["🏀 Basketball", "🤾‍♂️ Volleyball", "🏸 Badminton", "🏓 Tennis","🏒 Racquetball"]

let nwmissouriUsers: [String] = ["S549701@nwmissouri.edu","S554967@nwmissouri.edu","S591701@nwmissouri.edu","S589701@nwmissouri.edu","S569701@nwmissouri.edu","S949701@nwmissouri.edu","S556129@nwmissouri.edu"]

let courtsDict: [String: [String]] = [
    "🏀 Basketball": ["B1", "B2", "B3" , "B4"],
    "🤾‍♂️ Volleyball":   ["V1", "V2", "V3", "V4"],
    "🏸 Badminton": ["M1", "M2"],
    "🏓 Tennis": ["T1", "T2", "T3", "T4", "T5", "T6"],
    "🏒 Racquetball": ["R1", "R2", "R3"]
]

struct Model {
    let image: UIImage
    let title: String

    var inputSource: InputSource {
        return ImageSource(image: image)
    }
}
