//
//  FinalConfirmationViewController.swift
//  Framer
//
//  Created by Matthew Axner on 3/14/21.
//

import UIKit

class FinalConfirmationViewController: UIViewController {
    public var flow = 0
    //public var tempFrameImage: UIImage?
    //public var tempPhotoImage: UIImage?
    //public var inset: CGFloat?
    public var masterList = [Selection]()
    //public var frameIndex: Int?
    public var currentIndex: Int?
    public var arView: ARViewController?
    
    
    @IBOutlet weak var frameImage: UIImageView!
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        // Return to running AR Scene
        if (flow != 0) {
            print(masterList.count)
            if (flow == 1) {
                dismiss(animated: true, completion: nil)
            }
            else if (flow == 2) {
                arView!.currentIndex = currentIndex
                arView!.masterList = masterList
                self.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                
            }
            else if (flow == 3) {
                arView!.currentIndex = currentIndex
                arView!.masterList = masterList
                self.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }
        else { // Instantiate new AR View Controller
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

            let arViewController = storyBoard.instantiateViewController(withIdentifier: "ARViewController") as! ARViewController
            //arViewController.image = combineImages()
            arViewController.currentIndex = currentIndex
            arViewController.masterList = masterList
            self.show(arViewController, sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let H = (masterList[currentIndex!].photo!.size.height) + (2*((masterList[currentIndex!].frame!.capInsets.top)))
        let W = (masterList[currentIndex!].photo!.size.width) + (2*((masterList[currentIndex!].frame!.capInsets.left)))
        
        frameImage.heightAnchor.constraint(equalToConstant: H).isActive = true
        frameImage.widthAnchor.constraint(equalToConstant: W).isActive = true
        
        frameImage.image = masterList[currentIndex!].frame
        photoImage.image = masterList[currentIndex!].photo
        frameImage.layer.zPosition = 1
        photoImage.layer.zPosition = 2
        
        masterList[currentIndex!].fullImg = combineImages()
        
        
        // Do any additional setup after loading the view.
    }
    
    func combineImages()-> UIImage {  // could be rewritten to add dims directly to fullImg in Selection
            let bottomImage = frameImage.image
            let topImage = photoImage.image
        let size = CGSize(width: topImage!.size.width + masterList[currentIndex!].inset! * 2,
                          height: topImage!.size.height + masterList[currentIndex!].inset! * 2)
            UIGraphicsBeginImageContext(size)
            let areaSizeFrame = CGRect(x: 0, y: 0, width: size.width,
                                       height: size.height)
            bottomImage!.draw(in: areaSizeFrame)
            let areaSizePhoto = CGRect(x: masterList[currentIndex!].inset!, y: masterList[currentIndex!].inset!,
                                       width: size.width - masterList[currentIndex!].inset! * 2,
                                       height: size.height - masterList[currentIndex!].inset! * 2)
            topImage!.draw(in: areaSizePhoto, blendMode: .normal, alpha: 1.0)
            let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            //frameImage.image = nil
            //photoImage.image = newImage
            //UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil)
            return newImage
        }
    


}
