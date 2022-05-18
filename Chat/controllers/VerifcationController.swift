//
//  VerifcationController.swift
//  Chat
//
//  Created by amr on 11/05/2022.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class VerifcationController: UIViewController {
  
    @IBOutlet weak var verificationCode: UITextField!
    
    let db = Firestore.firestore()
    let ids = IDs()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        dismissKeyboard()
    }
    
    @IBAction func tapToVerfy(_ sender: UIButton) {
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID ?? "123",
            verificationCode: verificationCode.text!
        )
        var num : String?
        
       db.collection(ids.userProfile).getDocuments { snapShot, error in
            guard let data = snapShot?.documents else {
                return
            }
           for doc in data {
               // print(doc[self.ids.currentUserByPhone] as? String)
               // print(UserDefaults.standard.string(forKey: self.ids.uDPhoneNum))
               if doc[self.ids.currentUserByPhone] as? String == UserDefaults.standard.string(forKey: self.ids.uDPhoneNum){
                   num = doc[self.ids.currentUserByPhone] as? String
                   
               }
           }
           Auth.auth().signIn(with: credential) {[weak self] authResult, error in
               guard let strongSelf = self else{
                   return
               }
               if let error = error {
                   print(error.localizedDescription)
               }
               print("Sign in : \(String(describing: authResult))")
               
               if num == UserDefaults.standard.string(forKey: strongSelf.ids.uDPhoneNum) {
                   strongSelf.performSegue(withIdentifier: "userExiste", sender: self)
                   
               }else{
                   strongSelf.performSegue(withIdentifier: "VerificationDone", sender: self)
               }
               
           }
           
       }
        
        
        
        
        
        
        
        
        
        
    }
    
  
    
}
