//
//  PostViewController.swift
//  Parstagram
//
//  Created by Akarsh Kumar on 3/9/19.
//  Copyright © 2019 Akarsh Kumar. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class PostViewController: UIViewController, UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func postClicked(_ sender: UIButton) {
        let post = PFObject(className: "Post")
        
        post["caption"] = captionTextField.text!
        post["author"] = PFUser.current()!
        
        
        let imageData = imageView.image!.pngData()
        let file = PFFileObject(data: imageData!)
        
        post["image"] = file
        
        post.saveInBackground { (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
            }
            else {
                print("error posting")
            }
        }
        
    }
    
    @IBAction func onImageClicked(_ sender: UITapGestureRecognizer) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        if(UIImagePickerController.isSourceTypeAvailable(.camera)){
            imagePicker.sourceType = .camera
        }
        else{
            imagePicker.sourceType = .photoLibrary
        }
        
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 300, height: 300)
        
        let scaledImage = image.af_imageScaled(to: size)
        imageView.image = scaledImage
        
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
