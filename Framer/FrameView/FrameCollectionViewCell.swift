//
//  FrameCollectionViewCell.swift
//  Framer
//
//  Created by charles Simms on 3/13/21.
//

import UIKit

class FrameCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var ImageView: UIImageView!
    
    
    func insertImage(with image: UIImage) {
        ImageView.image = image
    }
}
