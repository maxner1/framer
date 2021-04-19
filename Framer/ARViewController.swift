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
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Create a new scene
        let scene = SCNScene()

        // Set the scene to the view
        sceneView.scene = scene
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        singleTap.numberOfTapsRequired = 1
        sceneView.addGestureRecognizer(singleTap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(dblTapped))
        doubleTap.numberOfTapsRequired = 2
        sceneView.addGestureRecognizer(doubleTap)
        
        singleTap.require(toFail: doubleTap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.vertical, .horizontal]

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
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        // make alignment vertical or horizontal  planeAnchor.alignment == .vertical
        let grid = Grid(anchor: planeAnchor)
        self.grids.append(grid)
        node.addChildNode(grid)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        // make alignment vertical or horizontal
        let grid = self.grids.filter { grid in
            return grid.anchor.identifier == planeAnchor.identifier
            }.first
        
        guard let foundGrid = grid else {
            return
        }
        
        foundGrid.update(anchor: planeAnchor)
    }
    
    func update() {
        for mlEntry in Range(uncheckedBounds: (0, masterList.endIndex)) {
            for snEntry in sceneView.scene.rootNode.childNodes {
                if ((snEntry.name == masterList[mlEntry].node?.name) && (masterList[mlEntry].hitTest != nil)) {
                    var alignment = 1  // vertical
                    if (snEntry.geometry as? SCNBox) != nil {
                        alignment = 0  // horizontal
                    }
                    snEntry.removeFromParentNode()
                    //print(mlEntry)
                    updatePainting(masterList[mlEntry].hitTest!, alignment)
                }
            }
        }
    }
    
    @objc func dblTapped(gesture: UITapGestureRecognizer) {
        // Get 2D position of touch event on screen
        let touchPosition = gesture.location(in: sceneView)
        
        // checking if hit existing selection
        let hitTest0 = sceneView.hitTest(touchPosition, options: [SCNHitTestOption.searchMode : 1])
        
        for result in hitTest0.filter( { $0.node.name != nil }) {
            for entry in Range(uncheckedBounds: (0, masterList.endIndex)) {
                if result.node.name == masterList[entry].node?.name {
                    // delete node
                    result.node.removeFromParentNode()
                    masterList[entry].node = nil
                    currentIndex = entry
                }
            }
        }
    }
    
    @objc func tapped(gesture: UITapGestureRecognizer) {
        // Get 2D position of touch event on screen
        let touchPosition = gesture.location(in: sceneView)
        
        // checking if hit existing selection
        let hitTest0 = sceneView.hitTest(touchPosition, options: [SCNHitTestOption.searchMode : 1])
        
        //guard gesture.state == .began else { return }
        for result in hitTest0.filter( { $0.node.name != nil }) {
            for entry in Range(uncheckedBounds: (0, masterList.endIndex)) {
                if result.node.name == masterList[entry].node?.name {
                    // go to final confirmation to edit
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let finalConfirmationVC = storyBoard.instantiateViewController(withIdentifier: "finalConfirmationVC") as! FinalConfirmationViewController
                    print(entry)
                    print(currentIndex!)
                    finalConfirmationVC.masterList = masterList
                    finalConfirmationVC.currentIndex = entry
                    finalConfirmationVC.arView = self
                    finalConfirmationVC.flow = 1
                    finalConfirmationVC.finalVC = finalConfirmationVC
                    self.present(finalConfirmationVC, animated: true, completion: nil)
                }
            }
        }
        
        // checking if hitting on plane to place
        // Translate those 2D points to 3D points using hitTest (existing plane)
        guard let query = sceneView.raycastQuery(from: touchPosition,
                                                   allowing: ARRaycastQuery.Target.existingPlaneGeometry,
                                                   alignment: ARRaycastQuery.TargetAlignment.any) else {
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
        if masterList[currentIndex!].node == nil {
            addPainting(hitTest, grids[gridIndex])
        }
    }
    
    func addPainting(_ hitResult: ARRaycastResult, _ grid: Grid) {
        let scalar = CGFloat(39.37)
        let width = masterList[currentIndex!].width / scalar
        let height = masterList[currentIndex!].height / scalar
        var node = SCNNode()
        
        if grid.anchor.alignment.rawValue == 1 { // vertical
            let planeGeometry = SCNPlane(width: width, height: height)
            let material = SCNMaterial()
            material.diffuse.contents = masterList[currentIndex!].fullImg
            planeGeometry.materials = [material]
            node = SCNNode(geometry: planeGeometry)
            node.transform = SCNMatrix4(hitResult.anchor!.transform)
            
        } else {  // horizontal
            let boxGeometry = SCNBox(width: width, height: 0.01, length: height, chamferRadius: 0)
            let selectMaterial = SCNMaterial()
            let material = SCNMaterial()
            selectMaterial.diffuse.contents = masterList[currentIndex!].fullImg
            material.diffuse.contents = UIColor.black
            boxGeometry.materials = [material, material, material, material, material, selectMaterial]
            node = SCNNode(geometry: boxGeometry)
        }
        
        node.transform = SCNMatrix4(hitResult.anchor!.transform)
        node.eulerAngles = SCNVector3(node.eulerAngles.x + (-Float.pi / 2), node.eulerAngles.y, node.eulerAngles.z)
        node.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y, hitResult.worldTransform.columns.3.z)
        node.name = String(currentIndex!)
        
        sceneView.scene.rootNode.addChildNode(node)
        grid.removeFromParentNode()
        masterList[currentIndex!].node = node
        masterList[currentIndex!].hitTest = hitResult
    }
    
    func updatePainting(_ hitResult: ARRaycastResult, _ alignment: Int) {
        let scalar = CGFloat(39.37)
        let width = masterList[currentIndex!].width / scalar
        let height = masterList[currentIndex!].height / scalar
        var node = SCNNode()
        
        if alignment == 1 { // vertical
            let planeGeometry = SCNPlane(width: width, height: height)
            let material = SCNMaterial()
            material.diffuse.contents = masterList[currentIndex!].fullImg
            planeGeometry.materials = [material]
            node = SCNNode(geometry: planeGeometry)
            
        } else {  // horizontal
            let boxGeometry = SCNBox(width: width, height: 0.01, length: height, chamferRadius: 0)
            let material = SCNMaterial()
            material.diffuse.contents = masterList[currentIndex!].fullImg
            boxGeometry.materials = [material]
            node = SCNNode(geometry: boxGeometry)
        }
  
        node.transform = SCNMatrix4(hitResult.anchor!.transform)
        node.eulerAngles = SCNVector3(node.eulerAngles.x + (-Float.pi / 2), node.eulerAngles.y, node.eulerAngles.z)
        node.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y, hitResult.worldTransform.columns.3.z)
        node.name = String(currentIndex!)
        
        sceneView.scene.rootNode.addChildNode(node)
        masterList[currentIndex!].node = node
    }
        
    @IBAction func AddImage(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let photoSelectionVC = storyBoard.instantiateViewController(withIdentifier: "PhotoSelectionVC") as! PhotoSelectionVC
        photoSelectionVC.flow = 2
        photoSelectionVC.arView = self
        self.present(photoSelectionVC, animated: true, completion: nil)
    }
}
