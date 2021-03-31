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
    public var inset: CGFloat?

    @IBOutlet weak var frameImage: UIImageView!
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        let arViewController = storyBoard.instantiateViewController(withIdentifier: "ARViewController") as! ARViewController
        arViewController.image = combineImages()
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
        

        // Do any additional setup after loading the view.
    }
    
    func combineImages()-> UIImage {
            let bottomImage = frameImage.image
            var topImage = photoImage.image
            var size = CGSize(width: topImage!.size.width + inset! * 2,
                              height: topImage!.size.height + inset! * 2)
            UIGraphicsBeginImageContext(size)
            let areaSizeFrame = CGRect(x: 0, y: 0, width: size.width,
                                       height: size.height)
            bottomImage!.draw(in: areaSizeFrame)
            let areaSizePhoto = CGRect(x: inset!, y: inset!,
                                       width: size.width - inset! * 2,
                                       height: size.height - inset! * 2)
            topImage!.draw(in: areaSizePhoto, blendMode: .normal, alpha: 1.0)
            var newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            //frameImage.image = nil
            //photoImage.image = newImage
            //UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil)
            return newImage
        }
    


}
