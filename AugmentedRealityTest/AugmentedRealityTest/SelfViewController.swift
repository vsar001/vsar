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
import Vision

class SelfViewController: UIViewController, ARSCNViewDelegate {

    
    var textStatement : String = ""
    
    @IBAction func writeNewStatetment(_ sender: UIButton) {
        let alert = UIAlertController(title: "Give Your Statement!", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Input your statement here..."
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            if let name = alert.textFields?.first?.text {
                print("Your name: \(name)")
                self.textStatement = name
            }
        }))
        
        self.present(alert, animated: true)
    }
    
    @IBOutlet weak var viewModeARSCN: ARSCNView!
    
    @IBOutlet weak var modelCollectionMenue: UICollectionView!
    private var scanTimer: Timer?
    private var scannedFaceViews = [UIView]()
    
    let wft : WorldFaceTracking = WorldFaceTracking()
    
    var santaHat = SCNNode()
    var modelScene : SCNScene?
    
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
     
        // creates text with depth
        let text = SCNText(string: textStatement, extrusionDepth: 1)
        
 
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
    
    func addModel(SceneView: ARSCNView) {
        //  let modelNode = SCNNode()
        
        //  let cc = getCameraCoordinates(SceneView: SceneView)
        //  modelNode.position = SCNVector3(cc.x, cc.y, cc.z)
        
        let model = SCNScene(named: "art.scnassets/SantaHat/SantaHat.scn")!
        SceneView.scene = model
        
        
        //let santaHatNode = model.rootNode.childNode(withName: "SantaHatNode", recursively: false)
        //santaHatNode?.position = SCNVector3(0,-3,-3)
        
        SceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            if (node.name == "SantaHatNode"){
                print("found hat!")
                santaHat = node
                santaHat.isHidden = true
                //santaHat.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: santaHat, options: nil))
            }
        }
        modelScene = model
        //   let wrapperNode = SCNNode()
        // for child in model.rootNode.childNodes{
        //   child.geometry?.firstMaterial?.lightingModel = .physicallyBased
        // wrapperNode.addChildNode(child)
        //}
        
        // modelNode.addChildNode(wrapperNode)
        
        
        
        // viewModeARSCN.scene.rootNode.addChildNode(modelNode)
        
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        guard ARFaceTrackingConfiguration.isSupported else {
            let alert = UIAlertController(title: "You're Using IPhone 7 or lower", message: "For SelfiCamera-AR-Experience you need IPhone 8 or higher! Use a Mirror to do your Settings over the FrontCamera!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            
            self.present(alert, animated: true)
            let configuration = ARWorldTrackingConfiguration()
            
            viewModeARSCN.session.run(configuration)
            
            
            scanTimer = Timer.scheduledTimer(timeInterval: 0.08, target: self, selector: #selector(scanForFaces), userInfo: nil, repeats: true)

            return }
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true

        viewModeARSCN.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        // Run the view's session
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        scanTimer?.invalidate()
        // Pause the view's session
        viewModeARSCN.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    

    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let faceNode = SCNNode()
        
        return faceNode
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
                    if (faces.isEmpty){
                        NSLog(" NO FACE FOUND !")
                        self.santaHat.isHidden = true
                    }
                    else{
                        for face in faces {
                            self.santaHat.isHidden = false
                            let faceView = UIView(frame: self.faceFrame(from: face.boundingBox))
                            
                            faceView.backgroundColor = .red
                            
                            let xUpperLeftFF = face.boundingBox.minX * self.viewModeARSCN.bounds.width
                            let yUpperLeftFF = (1 - face.boundingBox.maxY) * self.viewModeARSCN.bounds.height
                            let widthFF = face.boundingBox.width * self.viewModeARSCN.bounds.width
                            let heightFF = face.boundingBox.height * self.viewModeARSCN.bounds.height
                            let scaleFactor = ((widthFF/100)*(heightFF/100))/3
                            
                            NSLog("xFF : %f  yFF : %f", xUpperLeftFF, yUpperLeftFF)
                            NSLog("widthFF : %f  heightFF : %f", widthFF, heightFF)
                            NSLog("minX : %f  minY : %f", face.boundingBox.minX, face.boundingBox.minY)
                            NSLog("maxX : %f  maxY : %f", face.boundingBox.maxX, face.boundingBox.maxY)
                            NSLog("scaleFactor : %f", scaleFactor)
                            
                            let scaleAction = SCNAction.scale(to: scaleFactor, duration: 0.07)
                            let moveAction = SCNAction.move(to: SCNVector3((face.boundingBox.maxX/2),(face.boundingBox.minY),-1), duration: 0.07)
                            //let actionSequence = SCNAction.sequence([scaleAction,moveAction])
                            
                            self.santaHat.runAction(scaleAction)
                            self.santaHat.runAction(moveAction)
                            
                            
                            //self.santaHat.position = SCNVector3((widthFF/2),0,-3)
                            self.viewModeARSCN.scene = self.modelScene!
                            
                            self.viewModeARSCN.addSubview(faceView)
                            
                            self.scannedFaceViews.append(faceView)
                        }
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
}
