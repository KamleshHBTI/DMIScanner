//
//  VisionKitManager.swift
//  VisionKitTesting
//
//  Created by Surjeet Rajput on 22/09/19.
//  Copyright © 2019 indiGo. All rights reserved.
//

import Foundation
import UIKit
import Vision

public enum DetectionType {
    case vinPlate,
         barCode
}

enum DetectedInfo {
    case information(info: String?),
         barCode(barCode: String?)
}


//MARK: Typealias

typealias CardInformationReaderCompletion = ((DetectedInfo, Error?) -> Void)


class VisionKitManager {
    
    static let shared = VisionKitManager()
    
    private init() {
        print("Private initializer")
    }
    
}

extension VisionKitManager {
    
  func initializerVisionKitWith(image : UIImage,orientation :UIDeviceOrientation, detectionType: DetectionType, completion : CardInformationReaderCompletion?) {
        guard let cgImage = image.cgImage else {
            return
        }
    let requestHandler = VNImageRequestHandler(cgImage: cgImage, orientation: CGImagePropertyOrientation(rawValue: UInt32(orientation.rawValue))!, options: [:])
        self.handleVNImageRequestHandler(requestHandler, detectionType: detectionType, completion: completion)
    }
      
    func initializeVisionKitWithPixelBuffer(_ pixelBuffer : CVPixelBuffer, detectionType: DetectionType, completion : CardInformationReaderCompletion?) {
        //Always check for the orientation of the image. VIImageRequesthandler always assume image will be in upright orientation.
        //To initialize we can use CGIMage. Specify orientation through orientation property.
        //Use CVPixelBuffer from the live feed and data.
        //Chnage this orientation.
        //TODO: Detect orientation.
        let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])
        self.handleVNImageRequestHandler(requestHandler, detectionType: detectionType, completion: completion)
    }
    
    private func handleVNImageRequestHandler(_ requestHandler : VNImageRequestHandler, detectionType: DetectionType, completion : CardInformationReaderCompletion?) {
        //Create request.
        if #available(iOS 13.0, *) {
            switch detectionType {
            case .vinPlate:
                let request = VNRecognizeTextRequest { [weak self] (request, error) in
                    if let error = error {
                        completion?(.information(info: nil), error)
                        print("Some Error occured.: \(error)")
                    }else {
                        guard let observations = request.results as? [VNRecognizedTextObservation], observations.count > 0 else {
                            completion?(.information(info: nil), error)
                            print("Unable to find any words")
                            return
                        }
                        let information = observations.compactMap( { $0.topCandidates(1).first?.string })
                        let combinedInfo = information.reduce("") { "\($0)\($1)"}
                        print("Combined Info: \(combinedInfo)")
                        completion?(.information(info: combinedInfo), nil)
                    }
                }
                request.recognitionLevel = .accurate
                do {
                    try requestHandler.perform([request])
                } catch {
                    completion?(.information(info: nil), error)
                    print("Some error occured while processing request : \(error.localizedDescription)")
                }
            case .barCode:
                let request = VNDetectBarcodesRequest { [weak self] (request, error) in
                    if let error = error {
                        completion?(.barCode(barCode: nil), error)
                        print("Some Error occured.: \(error)")
                    }else {
                        guard let barCodeInfo = request.results?.first as? VNBarcodeObservation,
                              let barCodeString = barCodeInfo.payloadStringValue else {
                            completion?(.barCode(barCode: nil), error)
                            print("Unable to find any words")
                            return
                        }
                        completion?(.barCode(barCode: barCodeString), nil)
                    }
                }
                
                do {
                    try requestHandler.perform([request])
                } catch {
                    completion?(.barCode(barCode: nil), error)
                    print("Some error occured while processing request : \(error.localizedDescription)")
                }
                //Handle bar code.
                break
            }
            
        } else {
            // Fallback on earlier versions
        }
    }
}


