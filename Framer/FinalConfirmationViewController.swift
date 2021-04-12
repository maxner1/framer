//
//  FinalConfirmationViewController.swift
//  Framer
//
//  Created by Matthew Axner on 3/14/21.
//

import UIKit

class FinalConfirmationViewController: UIViewController, UITextFieldDelegate {
    
    public var tempFrameImage: UIImage?
    public var tempPhotoImage: UIImage?
    public var inset: CGFloat?
    

    @IBOutlet weak var frameImage: UIImageView!
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
        print("Result: ", result)
    }
    
    @IBOutlet weak var heightField: UITextField! {
        didSet {
            heightField?.addDoneCancelToolbar(onDone: (target: self, action: #selector(doneButtonTappedForHeightField)))
        }
    }

    @objc func doneButtonTappedForHeightField() {
        print("Done");
        let result = heightField.resignFirstResponder()
        print("Result: ", result)
    }
    
    var saved_height: String!
    var saved_width: String!
    

    @IBAction func doneButtonTapped(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        let arViewController = storyBoard.instantiateViewController(withIdentifier: "ARViewController") as! ARViewController
        arViewController.image = combineImages()
        self.show(arViewController, sender: nil)
    }
    
    func text_ht_return(textField: UITextField) -> Bool {
        saved_height = textField.text
        textField.resignFirstResponder()
        return false
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
