//
//  ViewController.swift
//  SeeFood
//
//  Created by Parth Antala on 2022-11-13.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var notHotDog: UIImageView!
    @IBOutlet weak var hotdog: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var isHot = ""
    let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        navigationController?.navigationBar.prefersLargeTitles = true
        
        label.text = ""
        label.backgroundColor = .clear
        
        label.isHidden = true
        hotdog.isHidden = true
        notHotDog.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        
    
    }
    
  
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            guard let ciimage = CIImage(image: image) else {
                fatalError("error")
            }
            detect(image: ciimage)
        }
        imagePicker.dismiss(animated: true)
    }
    
    func detect(image: CIImage){
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("loading coreml model failed.")
        }
        
        let request = VNCoreMLRequest(model: model) {(request, error) in
            guard let results = try? request.results as? [VNClassificationObservation] else {
                fatalError("model failed to process image")
            }
            print(results)
            if let firstResult = results.first {
                if firstResult.identifier.contains("hotdog") {
                    self.label.text = "HotDog"
                    self.label.backgroundColor = .green
                    self.isHot = "true"
                    self.label.isHidden = false
                    self.hotdog.isHidden = false
                    self.notHotDog.isHidden = true
   
                } else {
                    self.label.text = "Not HotDog!"
                    self.label.backgroundColor = .red
                    self.isHot = "false"
                    self.label.isHidden = false
                    self.hotdog.isHidden = false
                    self.notHotDog.isHidden = false

                }
              //  self.navigationItem.title = firstResult.identifier
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        do {
            try handler.perform([request])
        }
        catch{
            print("error")
        }
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
        present(imagePicker, animated: true)
    }
}

