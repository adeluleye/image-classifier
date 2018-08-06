//
//  ViewController.swift
//  SeeFood
//
//  Created by ADELU ABIDEEN ADELEYE on 8/6/18.
//  Copyright © 2018 Spantom Technologies Ltd. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let userPickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = userPickedImage
            
            guard let ciimage = CIImage(image: userPickedImage) else {
                
                fatalError("Could not convert to a CIImage")
            }
            
            detect(image: ciimage)
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image: CIImage) {
        //VNCoreMLModel is from the Vision Framework
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading Core ML Model Failed")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Unable to Process Image by the Model")
            }
            
            if let firstResult = results.first {
                
                //for broader classification
                self.navigationItem.title = firstResult.identifier
                
                /*if firstResult.identifier.contains("hotdog") {
                    self.navigationItem.title = "Hotdog"
                } else {
                    self.navigationItem.title = "Not HotDog"
                }*/
            }
        }
        
        // Create an handler for the image to be classified
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            print("Error occured, \(error)")
        }
        
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
}

