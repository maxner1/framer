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
    //public var masterList = [Selection]()
    //public var currentIndex: Int?
    // For recognizing how many views to dismiss
    public var flow = 0
    public var arView: ARViewController?
    public var finalVC: FinalConfirmationViewController?
    public var currentIndex: Int?
    public var masterList = [Selection]()
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
    
    
    @IBAction func ChoosePhotoFromDefault(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let defaultLibraryVC = storyBoard.instantiateViewController(withIdentifier: "DefaultLibraryVC") as! DefaultLibraryVC
        //defaultLibraryVC.masterList = masterList
        if (flow != 0) {
            if (flow == 1) {
                defaultLibraryVC.flow = 1
            }
            else {
                defaultLibraryVC.flow = 3
            }
            defaultLibraryVC.arView = arView
            defaultLibraryVC.finalVC = finalVC
            defaultLibraryVC.currentIndex = currentIndex
            defaultLibraryVC.masterList = masterList
        }
        self.present(defaultLibraryVC, animated: true, completion: nil)
    }
    
   
}

extension PhotoSelectionVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        print("here")
        
        if let img = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            picker.dismiss(animated: false, completion: nil)
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let camRollVC = storyBoard.instantiateViewController(withIdentifier: "CamRollVC") as! CamRollVC
            camRollVC.cameraRollPhoto = img
            camRollVC.flow = flow
            camRollVC.finalVC = finalVC
            camRollVC.currentIndex = currentIndex
            camRollVC.masterList = masterList
            if (flow != 0) {
                camRollVC.arView = arView
            }
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




