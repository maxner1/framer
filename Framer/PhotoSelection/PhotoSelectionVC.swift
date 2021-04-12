//
//  PhotoSelectionView.swift
//  Framer
//
//  Created by Anthony Ng on 3/11/21.
//

import Foundation
import UIKit

class PhotoSelectionVC: UIViewController {
    
    public var finalImage: UIImage!
    public var masterList: Selections!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func TakePhotoFromCam(_ sender: Any) {
        let ipc = UIImagePickerController()
        ipc.sourceType = .camera
        ipc.delegate = self
        ipc.allowsEditing = true
        present(ipc, animated: true)
    }
    
    @IBAction func ChoosePhotoFromCamRoll(_ sender: Any) {
        let ipc = UIImagePickerController()
        ipc.sourceType = .photoLibrary
        ipc.delegate = self
        ipc.allowsEditing = true
        present(ipc, animated: true)
    }
   
}

extension PhotoSelectionVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        print("here")
        
        if let img = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            picker.dismiss(animated: false, completion: nil)
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let camRollVC = storyBoard.instantiateViewController(withIdentifier: "CamRollVC") as! CamRollVC
            camRollVC.cameraRollPhoto = img;
//            navigationController?.pushViewController(newViewController, animated: true)
            self.finalImage = img
            self.present(camRollVC, animated: true, completion: nil)
//            self.performSegue(withIdentifier: "enlargeImageDefault", sender: self)
            picker.dismiss(animated: true, completion: nil)
        }
        print("here 2")
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: false, completion: nil)
    }
    

}




