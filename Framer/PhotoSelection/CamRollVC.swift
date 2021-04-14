
import Foundation
import UIKit

class CamRollVC: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    
    public var defaultPhoto : DefaultPhoto? = nil
    public var cameraRollPhoto : UIImage?
    public var finalPhoto : UIImage?
    public var masterList = [Selection]()
    public var currentIndex: Int?
    public var flow = 0
    public var arView: ARViewController?
    public var finalVC: FinalConfirmationViewController?
    
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
        /*
        if currentIndex != nil {
            masterList[currentIndex!].photo = finalPhoto
        }
        */
        
        let newSelection = Selection(img: finalPhoto!)
        if (flow != 0) {
            if (flow == 1) {
                arView!.masterList[currentIndex!].photo = finalPhoto
            } else {
                arView!.masterList.append(newSelection)
                arView!.currentIndex = arView!.masterList.endIndex - 1
                masterList = arView!.masterList
                currentIndex = arView!.currentIndex
            }
        }
        else {
            masterList.append(newSelection)
            currentIndex = masterList.endIndex - 1
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? FrameViewController {
            dest.selectedPhoto = finalPhoto
            dest.masterList = masterList
            dest.currentIndex = currentIndex
            dest.flow = flow
            dest.finalVC = finalVC
            if (flow != 0) {
                dest.arView = arView
            }
        }
    }
    @IBAction func backButtonClick(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        let photoSelectionVC = storyBoard.instantiateViewController(withIdentifier: "PhotoSelectionVC") as! PhotoSelectionVC
        photoSelectionVC.flow = flow
        photoSelectionVC.arView = arView
        photoSelectionVC.finalVC = finalVC
        self.show(photoSelectionVC, sender: nil)
    }
}

