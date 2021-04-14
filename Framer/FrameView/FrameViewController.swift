//
//  FrameViewController.swift
//  Framer
//
//  Created by charles Simms on 3/14/21.
//

import UIKit

extension UIImage {
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
    public var masterList = [Selection]()
    public var currentIndex: Int?
    public var flow = 0
    public var arView: ARViewController?
    public var finalVC: FinalConfirmationViewController?

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
            let inset = UIEdgeInsets(top: insets[chosenFrameIndex],
                                     left: insets[chosenFrameIndex],
                                     bottom: insets[chosenFrameIndex],
                                     right: insets[chosenFrameIndex])
            let finalF = chosenFrame.resizableImage(withCapInsets: inset, resizingMode: UIImage.ResizingMode.tile)
            let finalImg = selectedPhoto?.scaleI(inset: insets[chosenFrameIndex])

            masterList[currentIndex!].photo = finalImg
            masterList[currentIndex!].frame = finalF
            //dest.tempFrameImage = finalF
            //dest.tempPhotoImage = finalImg
            //masterList[currentIndex!].frameIndex = chosenFrameIndex
            masterList[currentIndex!].inset = insets[chosenFrameIndex]
            dest.masterList = masterList
            dest.currentIndex = currentIndex
            dest.flow = flow
            dest.finalVC = finalVC
            if (flow != 0) {
                dest.arView = arView
            }
            // pass in frame w/h somewhere in here

        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func backButtonClick(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        let camRollVC = storyBoard.instantiateViewController(withIdentifier: "CamRollVC") as! CamRollVC
        camRollVC.currentIndex = currentIndex
        camRollVC.masterList = masterList
        camRollVC.arView = arView
        camRollVC.flow = flow
        camRollVC.cameraRollPhoto = masterList[currentIndex!].photo!
        camRollVC.finalVC = finalVC
        self.show(camRollVC, sender: nil)
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
