//
//  VerifcationController.swift
//  Chat
//
//  Created by amr on 11/05/2022.
//

import UIKit
import FirebaseCore
import FirebaseAuth


class VerifcationController: UIViewController {
  
    @IBOutlet weak var verificationCode: UITextField!
    
   
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        dismissKeyboard()
    }
    
    @IBAction func tapToVerfy(_ sender: UIButton) {
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID!,
            verificationCode: verificationCode.text!
        )
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                print(error.localizedDescription)
            }
            print("Sign in : \(String(describing: authResult))")
            self.performSegue(withIdentifier: "VerificationDone", sender: self)
            
        }
        
    }
    
  
    
}
