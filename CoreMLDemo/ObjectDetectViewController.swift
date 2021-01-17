//
//  ObjectDetectViewController.swift
//  CoreMLDemo
//
//  Created by Sambit Das on 14/01/21.
//

import UIKit
import CoreML
import Vision
import Social
import Alamofire
import SwiftyJSON

class ObjectDetectViewController: UIViewController, UINavigationControllerDelegate {
    
    //MARK:- Outlets Connections and properties
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionBackGroundView: UIView!
    @IBOutlet weak var objectName: UILabel!
    @IBOutlet weak var objectDescription: UILabel!
    
    let imagePicker = UIImagePickerController()
    var wikipediaURL = "https://en.wikipedia.org/w/api.php"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI() {
        imagePicker.delegate = self
        descriptionBackGroundView.layer.cornerRadius = 40
    }
    
    private func singleObjectName(unfilteredName: String) -> String {
        let index = unfilteredName.firstIndex(of: ",") ?? unfilteredName.endIndex
        let firstObject = unfilteredName[..<index]
        return String(firstObject).capitalized
    }
    
    //MARK:- Detect Objects From VNCoreMLModel
    func detect(image: CIImage) {
        let config = MLModelConfiguration()
        guard let coreMLmodel = try? Inceptionv3(configuration: config),
              let visionModel = try? VNCoreMLModel(for: coreMLmodel.model) else {
            fatalError("can't load ML model")
        }
        let request = VNCoreMLRequest(model: visionModel) { request, error in
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first
            else {
                fatalError("unexpected result type from VNCoreMLRequest")
            }
            let acc = Int(topResult.confidence * 100)
            if acc <= 40 {
                print("Less Accuracy")
                self.objectName.text = "Oops!"
                self.objectDescription.text = "Sorry! We can't move forward due to less Accuracy. Please Try again."
                self.navigationItem.title = ""
            } else {
                self.navigationItem.title = "Accuracy : \(acc)"
                let finalName = self.singleObjectName(unfilteredName: topResult.identifier)
                self.requestInfo(ObjectName: finalName)
                self.objectName.text = finalName
            }
        }
        let handler = VNImageRequestHandler(ciImage: image)
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
    }
    
    //MARK:- Alamofire method
    private func requestInfo(ObjectName: String) {
        let parameters : [String:String] = [
            "format" : "json",
            "action" : "query",
            "prop" : "extracts",
            "exintro" : "",
            "explaintext" : "",
            "titles" : ObjectName,
            "indexpageids" : "",
            "redirects" : "1"
        ]
        
        AF.request(wikipediaURL, method: .get, parameters: parameters).response { (response) in
            switch response.result {
            case .success(let data) :
                print("we got success response")
                let jSONData: JSON = JSON(data as Any)
                let pageId = jSONData["query"]["pageids"][0].stringValue
                let objDesc = jSONData["query"]["pages"][pageId]["extract"].stringValue
                print(objDesc)
                self.objectDescription.text = objDesc
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK:- Interface Actions
    @IBAction func cameraTapped(_ sender: Any) {
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
}

//MARK:- UIImagePickerControllerDelegate
extension ObjectDetectViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            
            imageView.image = image
            imagePicker.dismiss(animated: true, completion: nil)
            guard let ciImage = CIImage(image: image) else {
                fatalError("couldn't convert uiimage to CIImage")
            }
            detect(image: ciImage)
        }
    }
}
