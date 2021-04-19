//
//  Grid.swift
//  Framer
//
//  Created by Elise Miller on 3/31/21.
//

import Foundation
import SceneKit
import ARKit

class Grid : SCNNode {
    
    var anchor: ARPlaneAnchor
    var planeGeometry: SCNPlane!
    
    init(anchor: ARPlaneAnchor) {
        self.anchor = anchor
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(anchor: ARPlaneAnchor) {
        
        if anchor.alignment.rawValue == 1 {  // vertical
            planeGeometry.width = CGFloat(anchor.extent.x);
            planeGeometry.height = CGFloat(anchor.extent.z);
            position = SCNVector3Make(anchor.center.x, 0, anchor.center.z);
            
            let planeNode = self.childNodes.first!
            planeNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: self.planeGeometry, options: nil))
            
        } else {  // horizontal
            //print("horizontal")
            planeGeometry.width = CGFloat(anchor.extent.x);
            planeGeometry.height = CGFloat(anchor.extent.z);
            position = SCNVector3Make(anchor.center.x, 0, anchor.center.z);
            
            let planeNode = self.childNodes.first!
            planeNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: self.planeGeometry, options: nil))
        }

    }
    
    private func setup() {
        
        if anchor.alignment.rawValue == 1 { // vertical
        
        
            planeGeometry = SCNPlane(width: CGFloat(self.anchor.extent.x), height: CGFloat(self.anchor.extent.z))
        
        
            let material = SCNMaterial()
        
            material.diffuse.contents = UIImage(named:"overlay_grid.png")
        
        
            planeGeometry.materials = [material]
        
            let planeNode = SCNNode(geometry: self.planeGeometry)
        
            planeNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: self.planeGeometry, options: nil))
        
            planeNode.physicsBody?.categoryBitMask = 2
        
        
            planeNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z);
        
            planeNode.transform = SCNMatrix4MakeRotation(Float(-Double.pi / 2.0), 1.0, 0.0, 0.0);

        
            addChildNode(planeNode)
            
        } else {  // horizontal
            //print("horizontal")
            planeGeometry = SCNPlane(width: CGFloat(self.anchor.extent.x), height: CGFloat(self.anchor.extent.z))
        
            let material = SCNMaterial()
        
            material.diffuse.contents = UIImage(named:"overlay_grid.png")
        
        
            planeGeometry.materials = [material]
        
            let planeNode = SCNNode(geometry: self.planeGeometry)
        
            planeNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: self.planeGeometry, options: nil))
        
            planeNode.physicsBody?.categoryBitMask = 2
        
        
            planeNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z);
        
            planeNode.transform = SCNMatrix4MakeRotation(Float(-Double.pi / 2.0), 1.0, 0.0, 0.0);
            // probably change above

            addChildNode(planeNode)
        }
    }
}
