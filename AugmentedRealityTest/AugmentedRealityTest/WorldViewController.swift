//
//  ViewModeController.swift
//  AugmentedRealityTest
//
//  Created by Anonymer Eintrag on 30.05.18.
//  Copyright © 2018 Anonymer Eintrag. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import Vision

class WorldViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var viewModeARSCN: ARSCNView!
    private var scanTimer: Timer?
    private var scannedFaceViews = [UIView]()
    
    private var imageOrientation: CGImagePropertyOrientation {
        switch UIDevice.current.orientation {
        case .portrait: return .right
        case .landscapeRight: return .down
        case .portraitUpsideDown: return .left
        case .unknown: fallthrough
        case .faceUp: fallthrough
        case .faceDown: fallthrough
        case .landscapeLeft: return .up
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        viewModeARSCN.delegate = self
        // Do any additional setup after loading the view.
        
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
        viewModeARSCN.scene.rootNode.addChildNode(node)
        addModel(SceneView: viewModeARSCN)
        viewModeARSCN.autoenablesDefaultLighting = true
        
    }
    //https://www.youtube.com/watch?v=tgPV_cRf2hA
    func addModel(SceneView: ARSCNView) {
      //  let modelNode = SCNNode()
        
      //  let cc = getCameraCoordinates(SceneView: SceneView)
      //  modelNode.position = SCNVector3(cc.x, cc.y, cc.z)
        
        let model = SCNScene(named: "art.scnassets/baymax/Bigmax_White_OBJ.scn")
        
        SceneView.scene = model!
        
     //   let wrapperNode = SCNNode()
       // for child in model.rootNode.childNodes{
         //   child.geometry?.firstMaterial?.lightingModel = .physicallyBased
           // wrapperNode.addChildNode(child)
        //}
        
       // modelNode.addChildNode(wrapperNode)
        
        
        
       // viewModeARSCN.scene.rootNode.addChildNode(modelNode)
        
    }
    struct myCameraCoordinates{
        var x = Float()
        var y = Float()
        var z = Float()
    }
    func getCameraCoordinates(SceneView: ARSCNView) -> myCameraCoordinates{
        let cameraTransform = viewModeARSCN.session.currentFrame?.camera.transform
        let cameraCoordinates = MDLTransform(matrix: cameraTransform!)
        
        var cc = myCameraCoordinates()
        cc.x = cameraCoordinates.translation.x
        cc.y = cameraCoordinates.translation.y
        cc.z = cameraCoordinates.translation.z
        
        return cc
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        viewModeARSCN.session.run(configuration)
        
        scanTimer = Timer.scheduledTimer(timeInterval: 0.08, target: self, selector: #selector(scanForFaces), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        scanTimer?.invalidate()
        // Pause the view's session
        viewModeARSCN.session.pause()
    }
    
    @objc
    private func scanForFaces() {
        
        //remove the test views and empty the array that was keeping a reference to them
        _ = scannedFaceViews.map { $0.removeFromSuperview() }
        scannedFaceViews.removeAll()
        
        //get the captured image of the ARSession's current frame
        guard let capturedImage = viewModeARSCN.session.currentFrame?.capturedImage else { return }
        
        let image = CIImage.init(cvPixelBuffer: capturedImage)
        
        let detectFaceRequest = VNDetectFaceRectanglesRequest { (request, error) in
            
            DispatchQueue.main.async {
                //Loop through the resulting faces and add a red UIView on top of them.
                if let faces = request.results as? [VNFaceObservation] {
                    for face in faces {
                        let faceView = UIView(frame: self.faceFrame(from: face.boundingBox))
                        
                        faceView.backgroundColor = .red
                        
                        self.viewModeARSCN.addSubview(faceView)
                        
                        self.scannedFaceViews.append(faceView)
                    }
                }
            }
        }
        
        DispatchQueue.global().async {
            try? VNImageRequestHandler(ciImage: image, orientation: self.imageOrientation).perform([detectFaceRequest])
        }
    }
    
    private func faceFrame(from boundingBox: CGRect) -> CGRect {
        
        //translate camera frame to frame inside the ARSKView
        let origin = CGPoint(x: boundingBox.minX * viewModeARSCN.bounds.width, y: (1 - boundingBox.maxY) * viewModeARSCN.bounds.height)
        let size = CGSize(width: boundingBox.width * viewModeARSCN.bounds.width, height: boundingBox.height * viewModeARSCN.bounds.height)
        
        return CGRect(origin: origin, size: size)
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
}

