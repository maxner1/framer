//
//  FrameViewController.swift
//  Framer
//
//  Created by charles Simms on 3/14/21.
//

import UIKit

class FrameViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let frames : [UIImage] = [#imageLiteral(resourceName: "Frame0"), #imageLiteral(resourceName: "Frame1"), #imageLiteral(resourceName: "Frame2"), #imageLiteral(resourceName: "Frame3"), #imageLiteral(resourceName: "Frame4"), #imageLiteral(resourceName: "Frame5")]
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
        if var dest = segue.destination as? FinalConfirmationViewController {
            let chosenFrame = frames[chosenFrameIndex]
            dest.tempFrameImage = chosenFrame
            dest.tempPhotoImage = selectedPhoto
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
