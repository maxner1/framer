//
//  PhotoSelectionView.swift
//  Framer
//
//  Created by Anthony Ng on 3/11/21.
//

import Foundation
import UIKit

extension PhotoSelectionVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let img = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            image = img;
            picker.dismiss(animated: true, completion: nil)
            performSegue(withIdentifier: "enlargeImageCameraRoll", sender: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

class PhotoSelectionVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var image : UIImage?

    @IBAction func ChoosePhotoFromCamRoll(_ sender: Any) {
        let ipc = UIImagePickerController()
        ipc.sourceType = .photoLibrary
        ipc.delegate = self
        ipc.allowsEditing = true
        present(ipc, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "enlargeImageCameraRoll" {
            let destinationController = segue.destination as! CamRollVC
            destinationController.cameraRollPhoto = image;
        }
    }
   
}





