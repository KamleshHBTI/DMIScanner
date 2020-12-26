//
//  ViewController.swift
//  VisionKitTesting
//
//  Created by Surjeet Rajput on 21/09/19.
//  Copyright © 2019 indiGo. All rights reserved.
//

import UIKit

class DMIScanner: UIViewController {
  
  
  public var currentDetection = DetectionType.barCode
  public var resultString:String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}

extension DMIScanner {
    @IBAction public func openCameraButtonTapped(_ sender : UIButton) {
    let controller = CustomCameraVC.customCameraVCWithDetectionType(self.currentDetection) { (info, error) in
      switch info {
      case .information(let info):
        self.resultString = info
        break
      case .barCode(let barCode):
        self.resultString = barCode
        break
      }
    }
    self.present(controller, animated: true, completion: nil)
  }
}





