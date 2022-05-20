//
//  ProfileView.swift
//  Chat
//
//  Created by amr on 12/05/2022.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class ProfileView: UIViewController {
   
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    let db = Firestore.firestore()
    let ids = IDs()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage?.layer.cornerRadius = (profileImage?.frame.size.width ?? 0.0) / 2

       retriveData()
    }
    

    func retriveData(){
        
        db.collection(self.ids.userProfile).getDocuments { snapshot, error in
            if error == nil && snapshot != nil {
                var imagePath = [String]()
               
                let currentUser = UserDefaults.standard.string(forKey: self.ids.uDPhoneNum)
               
                for doc in snapshot!.documents{
                    let phoneNumber = doc[self.ids.currentUserByPhone] as? String
                    if currentUser == phoneNumber {
                        imagePath.append(doc[self.ids.userImage] as! String)
                        self.labelName.text = (doc[self.ids.currentUserName] as! String)
                        self.phoneNumber.text = phoneNumber
                    }else{
                        print("Bad Luck")
                    }
                    
                }
                
                for iPath in imagePath {
                    let storageRef = Storage.storage().reference()
                    let fileRef = storageRef.child(iPath)
                    fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                        if error == nil && data != nil {
                            let image = UIImage(data: data!)
                        
                            DispatchQueue.main.async {
                             
                                self.profileImage.image = image
                            }
                            
                        }
                    }
                }
                
                
            }else{
                print(error?.localizedDescription ?? "Can't Defien ther erorr")
            }
        }
    }

    @IBAction func changeImage(_ sender: UIButton) {
        print("Button Taped")
    }
}
