//
//  FinalConfirmationViewController.swift
//  Framer
//
//  Created by Matthew Axner on 3/14/21.
//

import UIKit

class FinalConfirmationViewController: UIViewController, UITextFieldDelegate {
    public var flow = 0
    public var tempPhotoImage: UIImage?
    //public var inset: CGFloat?
    public var masterList = [Selection]()
    public var user_img_sz = CGSize.init()
    public var img_ratio: CGFloat?
    public var original_img : UIImage?
    public var frameImage: UIImage?
    //public var frameIndex: Int?
    public var currentIndex: Int?
    public var arView: ARViewController?
    
    
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var widthField: UITextField! {
        didSet {
            widthField?.addDoneCancelToolbar(onDone: (target: self, action: #selector(doneButtonTappedForWidthField)))
        }
    }

    @objc func doneButtonTappedForWidthField() {
        print("Done");
        let result = widthField.resignFirstResponder()
        let user_width = (Int(widthField.text!) ?? 1) * 20
        print("Result: ", result)
        // Calculate new aspect ratio
        if (user_img_sz.width <= CGFloat(user_width)) {
            // Save user input for width
            let nr = CGFloat(user_width) / user_img_sz.width
            user_img_sz.width = CGFloat(user_width)
            user_img_sz.height = nr * user_img_sz.height
        }
        else {
            let nr = user_img_sz.width / CGFloat(user_width)
            user_img_sz.width = CGFloat(user_width)
            user_img_sz.height = user_img_sz.height / nr
        }
        
        tempPhotoImage = resizeImage(image: original_img!, targetSize: user_img_sz)
        //tempFrameImage = resizeImage(image: original_frame!, targetSize: user_frame_sz)
        photoImage.image = tempPhotoImage
        //frameImage.image = tempFrameImage
    }
    
    @IBOutlet weak var heightField: UITextField! {
        didSet {
            heightField?.addDoneCancelToolbar(onDone: (target: self, action: #selector(doneButtonTappedForHeightField)))
        }
    }

    @objc func doneButtonTappedForHeightField() {
        print("Done");
        let result = heightField.resignFirstResponder()
        let user_ht = (Int(heightField.text!) ?? 1) * 20
        print("Result: ", result)
        // Calculate new aspect ratio
        if (user_img_sz.height <= CGFloat(user_ht)) {
            // Save user input for width
            let nr = CGFloat(user_ht) / user_img_sz.height
            user_img_sz.height = CGFloat(user_ht)
            user_img_sz.width = nr * user_img_sz.width
        }
        else {
            let nr = user_img_sz.height / CGFloat(user_ht)
            user_img_sz.height = CGFloat(user_ht)
            user_img_sz.width = user_img_sz.width / nr
        }
        
        tempPhotoImage = resizeImage(image: original_img!, targetSize: user_img_sz)
        photoImage.image = tempPhotoImage
    }
    
    var saved_height: String!
    var saved_width: String!
    

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
    
    func text_ht_return(textField: UITextField) -> Bool {
        saved_height = textField.text
        textField.resignFirstResponder()
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let H = (masterList[currentIndex!].photo!.size.height) + (2*((masterList[currentIndex!].frame!.capInsets.top)))
        let W = (masterList[currentIndex!].photo!.size.width) + (2*((masterList[currentIndex!].frame!.capInsets.left)))
        
        frameImage = masterList[currentIndex!].frame
        photoImage.image = masterList[currentIndex!].photo
        photoImage.layer.zPosition = 2
        
        masterList[currentIndex!].fullImg = combineImages()
        
        photoImage.image = masterList[currentIndex!].fullImg
        
        tempPhotoImage = masterList[currentIndex!].fullImg
        
        original_img = masterList[currentIndex!].fullImg
        
        user_img_sz.width = (masterList[currentIndex!].photo?.size.width)!
        user_img_sz.height = (tempPhotoImage?.size.height)!
        img_ratio = user_img_sz.width / user_img_sz.height
        tempPhotoImage = resizeImage(image: tempPhotoImage!, targetSize: user_img_sz)
        
        widthField.text = "\(Int(user_img_sz.width/20))"
        heightField.text = "\(Int(user_img_sz.height/20))"
        
        
        // Do any additional setup after loading the view.
        
        let widthField = UITextField()
        widthField.keyboardType = .numberPad
        widthField.delegate = self
        widthField.addTarget(self,
            action: #selector(self.textFieldFilter), for: .editingChanged)
        
        let heightField = UITextField()
        heightField.keyboardType = .numberPad
        heightField.delegate = self
        heightField.addTarget(self,
            action: #selector(self.textFieldFilter), for: .editingChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func textField(_ textField: UITextField,
      shouldChangeCharactersIn range: NSRange,
      replacementString string: String) -> Bool {
      let invalidCharacters =
        CharacterSet(charactersIn: "0123456789").inverted
      return (string.rangeOfCharacter(from: invalidCharacters) == nil)
    }
    
    @objc private func textFieldFilter(_ textField: UITextField) {
      if let text = textField.text, let intText = Int(text) {
        textField.text = "\(intText)"
      } else {
        textField.text = ""
      }
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: targetSize).image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
    
    func combineImages()-> UIImage {  // could be rewritten to add dims directly to fullImg in Selection
            let bottomImage = frameImage
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



extension UITextField {
    func addDoneCancelToolbar(onDone: (target: Any, action: Selector)? = nil, onCancel: (target: Any, action: Selector)? = nil) {
        let onCancel = onCancel ?? (target: self, action: #selector(cancelButtonTapped))
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))

        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: onCancel.target, action: onCancel.action),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
        ]
        toolbar.sizeToFit()

        self.inputAccessoryView = toolbar
    }

    // Default actions:
    @objc func doneButtonTapped() { self.resignFirstResponder() }
    @objc func cancelButtonTapped() { self.resignFirstResponder() }
}
