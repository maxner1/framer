//
//  ARViewController.swift
//  Framer
//
//  Created by Matthew Axner on 3/19/21.
//

import UIKit
import ARKit

class ARViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        runSesson()
        // Do any additional setup after loading the view.
    }
    
    func runSesson() {
        sceneView.delegate = self
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration)
    }
    

}

extension ARViewController: ARSCNViewDelegate {
    
}
