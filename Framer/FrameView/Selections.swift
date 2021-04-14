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

class Selection {
    var photo: UIImage?
    var photoW: CGFloat = 0
    var photoH: CGFloat = 0
    //var frameIndex: Int?
    var frame: UIImage?
    var inset: CGFloat?
    var frameW: CGFloat = 0
    var frameH: CGFloat = 0
    var fullImg: UIImage?
    
    var anchor: ARAnchor?  // might not use
    var hitTest: ARRaycastResult?
    var node: SCNNode?
    var planeGeometry: SCNPlane! // might not use
    
    //init(anchor: ARPlaneAnchor) {
    //    self.anchor = anchor
    //    super.init()
    //}
    
    init(img: UIImage) {
        self.photo = img
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

