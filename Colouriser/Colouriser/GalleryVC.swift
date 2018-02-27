//
//  Gallery.swift
//  Colouriser
//
//  Created by Group 1 on 1/1/18.
//  Copyright © 2018 Group 1. All rights reserved.
//
// move code maybe to own VC
import UIKit

class GalleryVC: UIViewController, UINavigationControllerDelegate , UIImagePickerControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        imageView.backgroundColor = UIColor.lightGray
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = selectedImage
        
        
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        
        present(controller, animated: true, completion: nil)
    }

}
