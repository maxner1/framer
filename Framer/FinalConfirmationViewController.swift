//
//  FinalConfirmationViewController.swift
//  Framer
//
//  Created by Matthew Axner on 3/14/21.
//

import UIKit

class FinalConfirmationViewController: UIViewController {
    
    public var tempFrameImage: UIImage?
    public var tempPhotoImage: UIImage?

    @IBOutlet weak var frameImage: UIImageView!
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        let arViewController = storyBoard.instantiateViewController(withIdentifier: "ARViewController") as! ARViewController
        self.show(arViewController, sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // print(tempFrameImage)
        // print(tempPhotoImage)
        
        let H = (tempPhotoImage?.size.height)! + (2*((tempFrameImage?.capInsets.top)!))
        let W = (tempPhotoImage?.size.width)! + (2*((tempFrameImage?.capInsets.left)!))
        
        frameImage.heightAnchor.constraint(equalToConstant: H).isActive = true
        frameImage.widthAnchor.constraint(equalToConstant: W).isActive = true
        
        frameImage.image = tempFrameImage
        photoImage.image = tempPhotoImage
        frameImage.layer.zPosition = 1
        photoImage.layer.zPosition = 2
        
        
        
        //let heightConstraint = NSLayoutConstraint(item: frameImage as Any, attribute: .height, relatedBy: .equal, toItem: photoImage, attribute: .height, multiplier: 1.0, constant: -(2*(frameImage.image?.capInsets.top)!))
        //let widthConstraint = NSLayoutConstraint(item: frameImage as Any, attribute: .width, relatedBy: .equal, toItem: photoImage, attribute: .width, multiplier: 1.0, constant: -(2*(frameImage.image?.capInsets.left)!))
        //frameImage.addConstraints([heightConstraint, widthConstraint])
        

        // Do any additional setup after loading the view.
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if var dest = segue.destination as? ARViewController {
//            print("Within prepare for Final")
//        }
//    }

}
