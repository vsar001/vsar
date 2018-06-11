//
//  ViewController.swift
//  AugmentedRealityTest
//
//  Created by Anonymer Eintrag on 30.05.18.
//  Copyright © 2018 Anonymer Eintrag. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class SelfViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    
    @IBOutlet weak var modelCollectionMenue: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Set the view's delegate
        sceneView.delegate = self
     
        // creates text with depth
        let text = SCNText(string: " was geht jo !", extrusionDepth: 1)
        
 
        // creates material object, sets color, assigns material to text
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.green
        text.materials = [material]

        // creates node, sets position, scales size of text, sets textgeometry to node
        let node = SCNNode()
        node.position = SCNVector3(x: 0, y:0.02, z: -0.1)
        node.scale = SCNVector3(x: 0.01, y: 0.01, z: 0.01)
        node.geometry = text
        
        // adds node to view, enable lighting to display shadows
        sceneView.scene.rootNode.addChildNode(node)
        
        
        sceneView.autoenablesDefaultLighting = true
        
    }
    

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        guard ARFaceTrackingConfiguration.isSupported else {
            let alert = UIAlertController(title: "You're Using IPhone 7 or lower", message: "For SelfiCamera-AR-Experience you need IPhone 8 or higher! Use a Mirror to do your Settings over the FrontCamera!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            
            self.present(alert, animated: true)
            let configuration = ARWorldTrackingConfiguration()
            
            sceneView.session.run(configuration)
            return }
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])

        // Run the view's session
        
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
}
