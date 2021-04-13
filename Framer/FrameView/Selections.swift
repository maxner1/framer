//
//  Selections.swift
//  Framer
//
//  Created by Elise Miller on 4/11/21.
//

import Foundation
import UIKit
import SceneKit
import ARKit

class Selection : SCNNode {
    var photo: UIImage?
    var photoW: CGFloat = 0
    var photoH: CGFloat = 0
    var frameIndex: Int?
    var frameW: CGFloat = 0
    var frameH: CGFloat = 0
    var fullImg: UIImage?
    
    var anchor: ARAnchor?  // might not use
    var planeGeometry: SCNPlane! // might not use
    
    //init(anchor: ARPlaneAnchor) {
    //    self.anchor = anchor
    //    super.init()
    //}
    
    init(img: UIImage) {
        self.photo = img
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

