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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
