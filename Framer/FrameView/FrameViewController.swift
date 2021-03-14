//
//  FrameViewController.swift
//  Framer
//
//  Created by charles Simms on 3/14/21.
//

import UIKit

class FrameViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let frames : [String] = ["Charles", "Alex", "Matt", "Blake", "Elise", "Anthony"]

    @IBOutlet weak var collection: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return frames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = FrameCollectionViewCell()
        
        if let framecell = collectionView.dequeueReusableCell(withReuseIdentifier: "frame", for: indexPath) as? FrameCollectionViewCell {
            
            framecell.insertImage(with: #imageLiteral(resourceName: "Frame1"))
            
            cell = framecell
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(frames[indexPath.row])
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
