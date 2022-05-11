//
//  ProfileController.swift
//  Chat
//
//  Created by amr on 11/05/2022.
//

import UIKit
import FirebaseFirestore

class ProfileController: UIViewController {
    let db = Firestore.firestore()
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveData(_ sender: UIButton) {
        var ref: DocumentReference? = nil
        ref = db.collection("users").addDocument(data: [
            "first": nameTextField.text!,
            "email": emailTextField.text!,
        ]) { err in
            if let err = err {
                print("Error adding document: \(err.localizedDescription)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }

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
