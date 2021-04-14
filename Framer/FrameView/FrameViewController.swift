//
//  FrameViewController.swift
//  Framer
//
//  Created by charles Simms on 3/14/21.
//

import UIKit

extension UIImage {
    func scaleImage(ratio: (CGFloat, CGFloat)) -> UIImage {
        let maxWidth = CGFloat(370)
        let maxHeight = CGFloat(500)
        let viewRatio = CGFloat(0.74)
        let imgRatio = size.width / size.height
        
        var frameWidth = CGFloat(0)
        var frameHeight = CGFloat(0)
        var imgWidth = CGFloat(0)
        var imgHeight = CGFloat(0)
        
        if imgRatio >= viewRatio {
            frameWidth = maxWidth
            let edges = frameWidth * ratio.0
            imgWidth = frameWidth - edges
            imgHeight = imgWidth / imgRatio
            frameHeight = imgHeight / (1 - ratio.1)
        } else {
            frameHeight = maxHeight
            let edges = frameHeight * ratio.1
            imgHeight = frameHeight - edges
            imgWidth = imgHeight * imgRatio
            frameWidth = imgWidth / (1 - ratio.0)
        }
        
        let newImgSize = CGSize(
            width: imgWidth,
            height: imgHeight
        )
            
        // Draw and return the resized UIImage
        let imgRenderer = UIGraphicsImageRenderer(
            size: newImgSize
        )
            
        let newImage = imgRenderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: newImgSize
            ))
        }
        return newImage
    }
    
    func scaleFrame(img: UIImage, ratio: (CGFloat, CGFloat)) -> UIImage {
        let maxWidth = CGFloat(370)
        let maxHeight = CGFloat(500)
        let viewRatio = CGFloat(0.74)
        let imgRatio = img.size.width / img.size.height
        
        var frameWidth = CGFloat(0)
        var frameHeight = CGFloat(0)
        var imgWidth = CGFloat(0)
        var imgHeight = CGFloat(0)
        
        if imgRatio >= viewRatio {
            frameWidth = maxWidth
            let edges = frameWidth * ratio.0
            imgWidth = frameWidth - edges
            imgHeight = imgWidth / imgRatio
            frameHeight = imgHeight / (1 - ratio.1)
        } else {
            frameHeight = maxHeight
            let edges = frameHeight * ratio.1
            imgHeight = frameHeight - edges
            imgWidth = imgHeight * imgRatio
            frameWidth = imgWidth / (1 - ratio.0)
        }
        
        let newFrameSize = CGSize(
            width: frameWidth,
            height: frameHeight
        )
            
        let frameRenderer = UIGraphicsImageRenderer(
            size: newFrameSize
        )
            
        let newFrame = frameRenderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: newFrameSize
            ))
        }
            
        return newFrame
        
    }
    
    func scaleF(img: UIImage) -> UIImage {
        let maxWidth = CGFloat(370)
        let maxHeight = CGFloat(500)
        let viewRatio = CGFloat(0.74)
        let imgRatio = img.size.width / img.size.height
        
        var frameWidth = CGFloat(0)
        var frameHeight = CGFloat(0)
        var imgWidth = CGFloat(0)
        var imgHeight = CGFloat(0)
        
        if imgRatio >= viewRatio {
            frameWidth = maxWidth
            let edges = self.capInsets.left + self.capInsets.right
            imgWidth = frameWidth - edges
            imgHeight = imgWidth / imgRatio
            frameHeight = imgHeight + self.capInsets.top + self.capInsets.bottom
        } else {
            frameHeight = maxHeight
            let edges = self.capInsets.top + self.capInsets.bottom
            imgHeight = frameHeight - edges
            imgWidth = imgHeight * imgRatio
            frameWidth = imgWidth + self.capInsets.left + self.capInsets.right
        }
        
        let newFrameSize = CGSize(
            width: frameWidth,
            height: frameHeight
        )
            
        let frameRenderer = UIGraphicsImageRenderer(
            size: newFrameSize
        )
            
        let newFrame = frameRenderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: newFrameSize
            ))
        }
            
        return newFrame
    }
    
    func scaleI(inset: CGFloat) -> UIImage {
        let maxWidth = CGFloat(370)
        let maxHeight = CGFloat(500)
        let viewRatio = CGFloat(0.74)
        let imgRatio = size.width / size.height
        
        var imgWidth = CGFloat(0)
        var imgHeight = CGFloat(0)
        
        if imgRatio >= viewRatio {
            imgWidth = maxWidth - (2 * inset)
            imgHeight = imgWidth / imgRatio
        } else {
            imgHeight = maxHeight - (2 * inset)
            imgWidth = imgHeight * imgRatio
        }
        
        let newImageSize = CGSize(
            width: imgWidth,
            height: imgHeight
        )
            
        let imgRenderer = UIGraphicsImageRenderer(
            size: newImageSize
        )
            
        let newImage = imgRenderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: newImageSize
            ))
        }
            
        return newImage
    }
}

class FrameViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let frames : [UIImage] = [#imageLiteral(resourceName: "Frame0"), #imageLiteral(resourceName: "Frame1"), #imageLiteral(resourceName: "Frame2"), #imageLiteral(resourceName: "Frame3"), #imageLiteral(resourceName: "Frame4"), #imageLiteral(resourceName: "Frame5"), #imageLiteral(resourceName: "Frame6"), #imageLiteral(resourceName: "Frame7"), #imageLiteral(resourceName: "Frame8"), #imageLiteral(resourceName: "Frame9"), #imageLiteral(resourceName: "Frame10"), #imageLiteral(resourceName: "Frame11"), #imageLiteral(resourceName: "Frame12")]
    let insets : [CGFloat] = [46, 80, 70, 40, 60, 42, 47, 70, 40, 25, 100, 10, 44]
    //    let insets : [CGFloat] = [46, 80, 70, 40, 60, 42, 47, 70, 40, 25, 70, 10, 44]

    private var chosenFrameIndex = 0
    public var selectedPhoto : UIImage?

    @IBOutlet weak var collection: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return frames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = FrameCollectionViewCell()
        
        if let framecell = collectionView.dequeueReusableCell(withReuseIdentifier: "frame", for: indexPath) as? FrameCollectionViewCell {
            
            let frameName = "Frame" + String(indexPath.row)
            let temp = UIImage(named: frameName)
            framecell.insertImage(with: temp!)
            
            cell = framecell
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(frames[indexPath.row])
        chosenFrameIndex = indexPath.row
        performSegue(withIdentifier: "finalConfirmationSegue", sender: nil)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? FinalConfirmationViewController {
            let chosenFrame = frames[chosenFrameIndex]
            //var frame = chosenFrame
            let inset = UIEdgeInsets(top: insets[chosenFrameIndex],
                                     left: insets[chosenFrameIndex],
                                     bottom: insets[chosenFrameIndex],
                                     right: insets[chosenFrameIndex])
            let finalF = chosenFrame.resizableImage(withCapInsets: inset, resizingMode: UIImage.ResizingMode.tile)
            let finalImg = selectedPhoto?.scaleI(inset: insets[chosenFrameIndex])
            //let finalFrame = finalF.scaleF(img: selectedPhoto!)
            //let finalImg = selectedPhoto?.scaleI()
            
            
            let bottomImage = finalImg!
            let topImage = chosenFrame

            let size = CGSize(width: 300, height: 300)
            UIGraphicsBeginImageContext(size)

            let areaS = CGRect(x: 0, y: 0, width: size.width - 40, height: size.height - 40)
            let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            bottomImage.draw(in: areaS)
            
            
            topImage.draw(in: areaSize, blendMode: .normal, alpha: 1)

            let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            dest.tryPhoto = newImage
            
            //let finalImg = selectedPhoto!.scaleImage(ratio: ratios[chosenFrameIndex])
            //let finalFrame = finalF.scaleFrame(img: selectedPhoto!)
            dest.tempFrameImage = chosenFrame
            dest.tempPhotoImage = finalImg
            dest.inset = insets[chosenFrameIndex]
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

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
