
import Foundation
import UIKit

class CamRollVC: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    public var defaultPhoto : DefaultPhoto? = nil
    public var cameraRollPhoto : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (defaultPhoto != nil) {
            imageView.image = UIImage(named: defaultPhoto?.image ?? "")
        }
        else {
          imageView.image = cameraRollPhoto
        }
        
    }
}

