//
//  PhotoPickerView.swift
//  Game Seer
//
//  Created by Никита Боровик on 11.06.2023.
//

import SwiftUI
import UIKit

struct PhPickerView: UIViewControllerRepresentable {
    
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var image: Data?
    @Binding var isPresented: Bool
    
    func makeCoordinator() -> PhotoPickerViewCoordinator {
        return PhotoPickerViewCoordinator(image: $image, isPresented: $isPresented)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = sourceType
        pickerController.delegate = context.coordinator
        return pickerController
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }

}

class PhotoPickerViewCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @Binding var image: Data?
    @Binding var isPresented: Bool
    
    init(image: Binding<Data?>, isPresented: Binding<Bool>) {
        self._image = image
        self._isPresented = isPresented
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.image = UIImage.pngData(image)()
        }
        self.isPresented = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.isPresented = false
    }
    
}

