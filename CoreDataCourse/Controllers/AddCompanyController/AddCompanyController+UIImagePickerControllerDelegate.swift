//
//  AddCompanyController+UIImagePickerControllerDelegate.swift
//  CoreDataCourse
//
//  Created by Ирина Улитина on 11/01/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit

extension AddCompanyController : UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        defer {
            dismiss(animated: true, completion: nil)
        }
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        selectImageView.image = image
        print(selectImageView.bounds)
    }
}

