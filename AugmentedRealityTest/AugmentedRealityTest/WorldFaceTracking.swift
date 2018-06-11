//
//  WorldFaceTracking.swift
//  AugmentedRealityTest
//
//  Created by MacBook on 07.06.18.
//  Copyright © 2018 Anonymer Eintrag. All rights reserved.
//
import UIKit
import Foundation
import Vision
import ARKit

class WorldFaceTracking{
    private var scanTimer: Timer?
    private var scannedFaceViews = [UIView]()
    public var viewModeARSCN: ARSCNView!
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
    @objc
    public func scanForFaces(viewModeARSCN: ARSCNView) {
        
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
                        
                        self.viewModeARSCN?.addSubview(faceView)
                        
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
        let origin = CGPoint(x: boundingBox.minX * (self.viewModeARSCN?.bounds.width)!, y: (1 - boundingBox.maxY) * (self.viewModeARSCN?.bounds.height)!)
        let size = CGSize(width: boundingBox.width * (self.viewModeARSCN?.bounds.width)!, height: boundingBox.height * (self.viewModeARSCN?.bounds.height)!)
        
        return CGRect(origin: origin, size: size)
    }
}
