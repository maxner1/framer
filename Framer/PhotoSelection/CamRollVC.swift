
import Foundation
import UIKit

class CamRollVC: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    public var defaultPhoto : DefaultPhoto? = nil
    public var cameraRollPhoto : UIImage?
    private var finalPhoto : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (defaultPhoto != nil) {
            imageView.image = UIImage(named: defaultPhoto?.image ?? "")
        }
        else {
          imageView.image = cameraRollPhoto
        }
        finalPhoto = imageView.image
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if var dest = segue.destination as? FrameViewController {
            dest.selectedPhoto = finalPhoto
        }
    }
}

