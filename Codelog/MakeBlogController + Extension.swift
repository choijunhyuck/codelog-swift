//
//  MakeBlogController + Extension.swift
//  Codelog
//
//  Created by 최준혁 on 27/11/2019.
//  Copyright © 2019 pirates. All rights reserved.
//

import UIKit

extension MakeBlogController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.editedImage] as? UIImage else {
            print("Error: \(info)")
            return
        }
        
        // do your thing...
        self.thumbnailView.image = selectedImage
        
        //Now use image to create into NSData format
        let imageData:NSData = selectedImage.pngData()! as NSData
         /*back
         let image = UIImage(data:imageData)
         */
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
    
}

