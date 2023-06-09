import Foundation
import UIKit
import CoreML
import Vision


class CoreMLClass {
    private let classifier: VNCoreMLModel

    init() {
        guard let model = try? Game_Seer(configuration: MLModelConfiguration()) else {
            fatalError("Cannt create game seer")
        }

        guard let localClassifier = try? VNCoreMLModel(for: model.model) else {
            fatalError("Cannt create vn core mobile")

        }
        classifier = localClassifier
    }

    func process(image: UIImage, onResult: @escaping ([String:Float]) -> Void) {
        let visionRequest = VNCoreMLRequest(model: classifier) { (request, error) in
            guard let result = request.results as? [VNClassificationObservation] else {
                onResult([:])
                return
            }
            let sequence = result.map {
                let label = $0.identifier
                let data = $0.confidence
                return (label, data)
            }
            let dictionary = Dictionary(uniqueKeysWithValues: sequence)
            onResult(dictionary)
        }
        guard let cgImage = image.cgImage else {
            fatalError("cant get cg image")
        }
        let visionHandler = VNImageRequestHandler(cgImage: cgImage)

        guard let result = try? visionHandler.perform([visionRequest]) else {
            fatalError("Cant process handler")
        }
    }
}
