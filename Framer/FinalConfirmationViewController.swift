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
        print(tempFrameImage)
        print(tempPhotoImage)
        frameImage.image = tempFrameImage
        photoImage.image = tempPhotoImage
        frameImage.layer.zPosition = 1
        photoImage.layer.zPosition = 2
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
