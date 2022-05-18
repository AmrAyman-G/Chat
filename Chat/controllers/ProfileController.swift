//
//  ProfileController.swift
//  Chat
//
//  Created by amr on 11/05/2022.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore



class ProfileController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    let db = Firestore.firestore()
    
    let ids = IDs()
   
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
//    @IBOutlet weak var emailTextField: UITextField!
    
//    var userProfile : [UserProfile] = [UserProfile(profileImage: UIImage(named: "test")! , name: "amr", email: "Email")]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        dismissKeyboard()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveData(_ sender: UIButton) {
        
        
        
        uploadData()
    
        
//        var ref: DocumentReference? = nil
//        ref = db.collection("users").addDocument(data: [
//            "first": nameTextField.text!,
//            "email": emailTextField.text!,
//        ]) { err in
//            if let err = err {
//                print("Error adding document: \(err.localizedDescription)")
//            } else {
//                print("Document added with ID: \(ref!.documentID)")
//            }
//        }

    }
    @IBAction func addImage(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let imageController = UIAlertController(title: "Add Image", message: nil, preferredStyle: .actionSheet)
        let camera =  UIAlertAction(title: "Camera", style: .default) { action in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePicker.sourceType = .camera
                imagePicker.isEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }else{
                let alert = UIAlertController(title: "No Camera Avilable", message: "Please check if your camera is working", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                    
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { action in
            imagePicker.sourceType = .photoLibrary
            imagePicker.isEditing  = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        imageController.addAction(camera)
        imageController.addAction(photoLibrary)
        imageController.addAction(cancel)
        
        self.present(imageController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.profileImage.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: UPLOAD MATHODE-
    func uploadData(){
        guard profileImage.image != nil else{
            return
        }
        let storageRef = Storage.storage().reference()
        
        let imageData = profileImage.image!.jpegData(compressionQuality: 0.8)
        
        guard imageData != nil else{
            return
        }
        let imagePath = "UserImage/\(UUID().uuidString).jpg"
        let fileRef = storageRef.child(imagePath)
        
      _ = fileRef.putData(imageData!, metadata: nil){ metadata, error in
            
            if error == nil && metadata != nil {
                
                if let phoneNum = UserDefaults.standard.string(forKey: "phoneNum"), let currentUserName = self.nameTextField.text {
                
                    self.db.collection(self.ids.userProfile).addDocument(data: [
                        self.ids.currentUserByPhone : phoneNum,
                        self.ids.currentUserName: currentUserName,
                        self.ids.userImage: imagePath]) { error in
                           if let error = error {
                               print("FireStore : \(error.localizedDescription)")
                           }else{
                               print("Successfully saved Data")
                               self.performSegue(withIdentifier: "profileDone", sender: self)
                           }
                       }
                   }
                
                
            }else{
                print("FireStorage : \(error?.localizedDescription ?? "Can't Defien ther erorr")")
            }
        }
    }
    
    
    
   
    
}

