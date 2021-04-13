//
//  ARViewController.swift
//  Framer
//
//  Created by Matthew Axner on 3/19/21.
//

import UIKit
import SceneKit
import ARKit

class ARViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    var grids = [Grid]()
    // var image: UIImage!
    public var masterList = [Selection]()
    public var currentIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //runSesson()
        // Do any additional setup after loading the view.
        
        // Set the view's delegate
        sceneView.delegate = self
        
        
        // Create a new scene
        let scene = SCNScene()

        // Set the scene to the view
        sceneView.scene = scene
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        sceneView.addGestureRecognizer(singleTap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(dblTapped))
        sceneView.addGestureRecognizer(doubleTap)
        singleTap.numberOfTapsRequired = 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .vertical

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor, planeAnchor.alignment == .vertical else { return }
        let grid = Grid(anchor: planeAnchor)
        self.grids.append(grid)
        node.addChildNode(grid)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor, planeAnchor.alignment == .vertical else { return }
        let grid = self.grids.filter { grid in
            return grid.anchor.identifier == planeAnchor.identifier
            }.first
        
        guard let foundGrid = grid else {
            return
        }
        
        foundGrid.update(anchor: planeAnchor)
    }
    
    @objc func dblTapped(gesture: UITapGestureRecognizer) {
        // for deletes
    }
    
    @objc func tapped(gesture: UITapGestureRecognizer) {
        // Get 2D position of touch event on screen
        let touchPosition = gesture.location(in: sceneView)
        
        // Translate those 2D points to 3D points using hitTest (existing plane)
        guard let query = sceneView.raycastQuery(from: touchPosition,
                                                   allowing: ARRaycastQuery.Target.existingPlaneGeometry,
                                                   alignment: ARRaycastQuery.TargetAlignment.vertical) else {
            return
        }
        
        guard let hitTest = sceneView.session.raycast(query).first else {
            return
        }
        
        let anchor = hitTest.anchor as? ARPlaneAnchor
        

        // Get hitTest results and ensure that the hitTest corresponds to a grid that has been placed on a wall
        guard let gridIndex = grids.firstIndex(where: { $0.anchor == anchor }) else {
            return  // if not even on grid, not on painting either
        }
        
        // check if on existing painting
        guard let mlIndex = masterList.firstIndex(where: { $0.hitTest == hitTest }) else {
            addPainting(hitTest, grids[gridIndex])  // if not on painting, still on grid
            return
        }
        
        // if painting tapped, edit it
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let finalConfirmationVC = storyBoard.instantiateViewController(withIdentifier: "finalConfirmationVC") as! FinalConfirmationViewController
        finalConfirmationVC.masterList = masterList
        finalConfirmationVC.currentIndex = mlIndex
        self.present(finalConfirmationVC, animated: true, completion: nil)
        // segue to confirmation screen with masterList[mlIndex]????
        // masterList[mlIndex].removeFromParentNode()
    }
    
    func addPainting(_ hitResult: ARRaycastResult, _ grid: Grid) {
        // 1.
        let planeGeometry = SCNPlane(width: 0.2, height: 0.35)
        masterList[currentIndex!].anchor = hitResult.anchor
        masterList[currentIndex!].hitTest = hitResult
        let material = SCNMaterial()
        material.diffuse.contents = masterList[currentIndex!].fullImg
        planeGeometry.materials = [material]
        
        // 2.
        let paintingNode = SCNNode(geometry: planeGeometry)
        paintingNode.transform = SCNMatrix4(hitResult.anchor!.transform)
        paintingNode.eulerAngles = SCNVector3(paintingNode.eulerAngles.x + (-Float.pi / 2), paintingNode.eulerAngles.y, paintingNode.eulerAngles.z)
        paintingNode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y, hitResult.worldTransform.columns.3.z)
        
        sceneView.scene.rootNode.addChildNode(paintingNode)
        grid.removeFromParentNode()
    }
    
    func runSesson() {
        sceneView.delegate = self
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration)
    }
        
    @IBAction func AddImage(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let photoSelectionVC = storyBoard.instantiateViewController(withIdentifier: "PhotoSelectionVC") as! PhotoSelectionVC
        photoSelectionVC.masterList = masterList
        photoSelectionVC.currentIndex = nil
        photoSelectionVC.flow = 2
        self.present(photoSelectionVC, animated: true, completion: nil)
    }
}

