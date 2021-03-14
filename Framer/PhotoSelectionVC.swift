//
//  PhotoSelectionView.swift
//  Framer
//
//  Created by Anthony Ng on 3/11/21.
//

import Foundation
import UIKit

class PhotoSelectionVC: UIViewController {
    
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
        
        if let img = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            picker.dismiss(animated: false, completion: nil)
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "CamRollVC") as! CamRollVC
            newViewController.cameraRollPhoto = img;
            navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}




