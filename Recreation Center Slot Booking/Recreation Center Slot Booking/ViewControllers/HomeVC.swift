 
import UIKit

 
class HomeVC: UIViewController {

  
    @IBOutlet weak var slot: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var courtId: UILabel!
    @IBOutlet weak var game: UILabel!
    @IBOutlet weak var containerview: DesignableView!
    @IBOutlet weak var recentBookingTitle: UILabel!
    @IBOutlet weak var imageSlideShow: ImageSlideshow!
    
    override func viewDidLoad() {
      
        setupImageSlideShow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false
      
        
       let bookings = DatabaseManager.databaseManager.getMyAllBookings()
        
        if(!bookings.isEmpty) {
           
            self.setData(booking: bookings.first!)
            self.recentBookingTitle.text = "Recent Booking"
        }else {
            
            self.recentBookingTitle.text = "You don't have any recent booking"
        }
        
    }
    
    func setData(booking:Booking) {
        
        self.slot.text = "Slot - \(booking.slot!)"
        self.date.text = "Booking Date - \(booking.date!)"
        self.courtId.text = "Court Id - \(booking.courtId!)"
        self.game.text = "Booked For - \(booking.game!)"
        
    }
    
  
    
}


extension HomeVC {
    

    func setupImageSlideShow() {
        
        let localSource = [BundleImageSource(imageString: "1"), BundleImageSource(imageString: "2"), BundleImageSource(imageString: "3"), BundleImageSource(imageString: "4")]
       
        imageSlideShow.slideshowInterval = 5.0
        imageSlideShow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        imageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFill

        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        pageControl.pageIndicatorTintColor = UIColor.black
        imageSlideShow.pageIndicator = pageControl

        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        imageSlideShow.activityIndicator = DefaultActivityIndicator()
        imageSlideShow.delegate = self

        // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
        imageSlideShow.setImageInputs(localSource)

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(HomeVC.didTap))
        imageSlideShow.addGestureRecognizer(recognizer)
        
        
    }

@objc func didTap() {
    let fullScreenController = imageSlideShow.presentFullScreenController(from: self)
    // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
    fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .medium, color: nil)
}
}

extension HomeVC: ImageSlideshowDelegate {
func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
   
}
}
