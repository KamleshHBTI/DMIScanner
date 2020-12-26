//
//  CustomCameraPreviewView.swift
//  VisionKitTesting
//
//  Created by Surjeet Rajput on 08/12/19.
//  Copyright © 2019 indiGo. All rights reserved.
//

import UIKit
import AVFoundation

class CustomCameraPreviewView: UIView {

    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        guard let layer = layer as? AVCaptureVideoPreviewLayer else {
            fatalError("Expected `AVCaptureVideoPreviewLayer` type for layer. Check PreviewView.layerClass implementation.")
        }
      print(layer.frame)
        return layer
    }
    
    var session: AVCaptureSession? {
        get {
            return videoPreviewLayer.session
        }
        set {
            videoPreviewLayer.session = newValue
        }
    }

  override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
}
