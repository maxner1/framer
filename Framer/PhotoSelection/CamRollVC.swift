
import Foundation
import UIKit

class CamRollVC: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    
    public var defaultPhoto : DefaultPhoto? = nil
    public var cameraRollPhoto : UIImage?
    private var finalPhoto : UIImage?
    public var masterList = [Selection]()
    public var currentIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (defaultPhoto != nil) {
            imageView.image = UIImage(named: defaultPhoto?.image ?? "")
        }
        else {
          imageView.image = cameraRollPhoto
        }
        finalPhoto = imageView.image
        
        // add/update masterList entry, resizing w/h to be added
        if currentIndex != nil {
            masterList[currentIndex!].photo = finalPhoto
        } else {
            let newSelection = Selection(img: finalPhoto!)
            masterList.append(newSelection)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? FrameViewController {
            dest.selectedPhoto = finalPhoto
            dest.masterList = masterList
            dest.currentIndex = currentIndex
        }
    }
}

