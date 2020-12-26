//
//  CustomCameraVC.swift
//  VisionKitTesting
//
//  Created by Surjeet Rajput on 08/12/19.
//  Copyright © 2019 indiGo. All rights reserved.
//

import UIKit
import AVFoundation

class CustomCameraVC: UIViewController {
  
  var previewView : CustomCameraPreviewView!
  
  var currentDetection = DetectionType.barCode
  var orientation:UIDeviceOrientation = UIDevice.current.orientation
  //MARK: Constants
  fileprivate static let queueName = "CustomCameraQueue"
  
  //MARK: variables.
  fileprivate var session = AVCaptureSession()
  
  var cardInformationHandler : CardInformationReaderCompletion?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.initialUISetup()
    previewView.session = session
    self.configureCaptureSession(self.session)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
//    let value = UIInterfaceOrientation.landscapeRight.rawValue
//    UIDevice.current.setValue(value, forKey: "orientation")
    session.startRunning()
  }
  
  override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation)  {
    switch UIDevice.current.orientation{
    case .portrait:
      return orientation = .portrait
    case .portraitUpsideDown:
      return orientation = .portraitUpsideDown
    case .landscapeLeft:
      return orientation = .landscapeLeft
    case .landscapeRight:
      return orientation = .landscapeRight
    default:
      return orientation = .portrait
    }
  }
//  override var shouldAutorotate: Bool {
////      return true
//  }
}

//MARK: UI Setup.
extension CustomCameraVC {
  
  func initialUISetup() {
    self.view.backgroundColor = UIColor.white
    self.previewView = setUpPreviewViewOnView(self.view)
  }
  
  func setUpPreviewViewOnView(_ parentView : UIView) -> CustomCameraPreviewView {
    let previewView = CustomCameraPreviewView()
    previewView.translatesAutoresizingMaskIntoConstraints = false
    parentView.addSubview(previewView)
    previewView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
    previewView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
    previewView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
    previewView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
    return previewView
  }
}


//MARK: Camera setup.
extension CustomCameraVC {
  
  func configureCaptureSession(_ session : AVCaptureSession) {
    //Begin configuration.
    session.beginConfiguration()
    
    //Add Imput device for photo.
    session.sessionPreset = .photo
    guard let photoCaptureDevice = AVCaptureDevice.default(for: .video) else {
      self.dismissIt()
      print("No Capture device  found.")
      return
    }
    do {
      let photoInputDevice = try AVCaptureDeviceInput(device: photoCaptureDevice)
      guard session.canAddInput(photoInputDevice) else {
        self.dismissIt()
        print("Unable to add input device.")
        return
      }
      session.addInput(photoInputDevice)
    } catch {
      self.dismissIt()
      print("Unable to add input device.")
    }
    //Add video output data.
    let videoOutput = AVCaptureVideoDataOutput()
    videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "\(CustomCameraVC.queueName)"))
    guard session.canAddOutput(videoOutput) else {
      print("Unable to add video output.")
      return
    }
    session.addOutput(videoOutput)
    session.commitConfiguration()
  }
  
}

extension CustomCameraVC : AVCaptureVideoDataOutputSampleBufferDelegate {
  
  func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    //TODO: Process this buffer.
    guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer),
          let uiImage = CIImage(cvImageBuffer: imageBuffer).toImage() else {
      return
    }
    VisionKitManager.shared.initializerVisionKitWith(image: uiImage,orientation: orientation, detectionType: self.currentDetection) { (info, error) in
      switch info {
      case .information(let cardInfo):
        if let cardInfo = cardInfo?.removeSpaces, cardInfo.isValidNumberPlate {
          DispatchQueue.main.async {
            self.dismiss(animated: true) {
              self.cardInformationHandler?(info, error)
            }
            print("Yeah we got info")
          }
        }else {
          print("Not valid Number")
        }
      case .barCode(let barCode):
        if let _ = barCode {
          DispatchQueue.main.async {
            self.dismiss(animated: true) {
              self.cardInformationHandler?(info, error)
            }
            print("Yeah we got info")
          }
        }
      }
      if let error = error {
        print("Error while parsing card info : \(error.localizedDescription)")
      }else {
        
      }
    }
  }
}

//MARK: Other Helper methods.
extension CustomCameraVC {
  
  /// This method will dimiss this controller.
  func dismissIt() {
    
  }
  
  static func customCameraVCWithDetectionType(_ detection: DetectionType,
                                              cardInformationHandler : CardInformationReaderCompletion?) -> CustomCameraVC {
    let customCameraVC = CustomCameraVC()
    customCameraVC.cardInformationHandler = cardInformationHandler
    customCameraVC.currentDetection = detection
    return customCameraVC
  }
}

extension CIImage {
  
  func toImage() -> UIImage? {
    let context : CIContext = CIContext(options: nil)
    if let cgImage = context.createCGImage(self, from: self.extent) {
      return UIImage(cgImage: cgImage)
    }else {
      return nil
    }
  }

}

