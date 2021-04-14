//
//  DefaultLibraryViewController.swift
//  Framer
//
//  Created by Anthony Ng on 3/13/21.
//

import Foundation
import UIKit

class DefaultLibraryVC: UICollectionViewController {
    public var flow = 0
    public var arView: ARViewController?
    public var finalVC: FinalConfirmationViewController?
    private var images : [DefaultPhoto] = [ DefaultPhoto(image: "image1"),
                                        DefaultPhoto(image: "image2"),
                                        DefaultPhoto(image: "image3"),
                                        DefaultPhoto(image: "image4"),
                                        DefaultPhoto(image: "image5"),
                                        DefaultPhoto(image: "image6"),
                                        DefaultPhoto(image: "image7"),
                                        DefaultPhoto(image: "image8"),
                                        DefaultPhoto(image: "image9"),
                                        DefaultPhoto(image: "image10"),
                                        DefaultPhoto(image: "image11"),
                                        DefaultPhoto(image: "image12"),
                                        DefaultPhoto(image: "image13"),
                                        DefaultPhoto(image: "image14"),
                                        DefaultPhoto(image: "image15"),
                                        DefaultPhoto(image: "image16"),
                                        DefaultPhoto(image: "image17"),
                                        DefaultPhoto(image: "image18"),
                                        DefaultPhoto(image: "image19"),
                                        DefaultPhoto(image: "image20"),
                                        DefaultPhoto(image: "image21"),
                                        DefaultPhoto(image: "image22"),
                                        DefaultPhoto(image: "image23"),
                                        DefaultPhoto(image: "image24")]
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dataCell", for: indexPath) as! DefaultPhotoCell
        let image = images[indexPath.row]
        cell.defaultImageView.image = UIImage(named: image.image)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "enlargeImageDefault" {
            if let indexPaths = collectionView.indexPathsForSelectedItems{
                let destinationController = segue.destination as! CamRollVC
                destinationController.defaultPhoto = images[indexPaths[0].row]
                destinationController.flow = flow
                if (flow != 0) {
                    destinationController.arView = arView
                    destinationController.finalVC = finalVC
                }
                collectionView.deselectItem(at: indexPaths[0], animated: false)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "enlargeImageDefault", sender: nil)
    }
}
