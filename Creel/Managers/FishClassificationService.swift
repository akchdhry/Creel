//
//  FishClassificationService.swift
//  Creel
//
//  Created by Aareb Chowdhury on 6/18/25.
//

import Foundation
import AVFoundation
import Vision
import CoreML
import UIKit

class FishClassificationService: ObservableObject {
    private var model: VNCoreMLModel?
    
    init() {
        loadModel()
    }
    
    private func loadModel() {
        // TODO: Load your trained fish classification model
        // guard let modelURL = Bundle.main.url(forResource: "FishClassifier", withExtension: "mlmodelc"),
        //       let mlModel = try? MLModel(contentsOf: modelURL),
        //       let visionModel = try? VNCoreMLModel(for: mlModel) else {
        //     print("Failed to load fish classification model")
        //     return
        // }
        // self.model = visionModel
    }
    
    func classifyFish(image: UIImage, completion: @escaping (String, Double) -> Void) {
        guard let model = model,
              let cgImage = image.cgImage else {
            completion("Unknown", 0.0)
            return
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first else {
                completion("Unknown", 0.0)
                return
            }
            
            DispatchQueue.main.async {
                completion(topResult.identifier, Double(topResult.confidence))
            }
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try? handler.perform([request])
    }
}
