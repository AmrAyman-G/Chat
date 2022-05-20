//
//  PhoneController.swift
//  Chat
//
//  Created by amr on 09/05/2022.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore


class PhoneController: UIViewController {
   
    
    
    
    
    @IBOutlet weak var VerifcationButton: UIButton!
    @IBOutlet weak var phoneTextfield: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var btnCountery: UIButton!
    
    var name:String = "Choose a country"
    var code:String?
    var fullPhoneNum : String?
//    let db = Firestore.firestore()
    let ids = IDs()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
       
        btnCountery.addTarget(self, action: #selector(tapForCountery), for: .touchUpInside)
        self.hideKeyboardWhenTappedAround()
        dismissKeyboard()
        phoneTextfield.isEnabled = false
        codeTextField.isEnabled = false
        codeTextField.text = nil
        phoneTextfield.text = nil
        
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")else{
            return
        }
        print(verificationID)
        
    
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        countryName.text = name
        if let cCode = code{
            codeTextField.text = cCode
            if codeTextField.text != nil {
                phoneTextfield.isEnabled = true
                self.phoneTextfield.becomeFirstResponder()
            }
        }
    }
    
    @IBAction func phoneValidation(_ sender: Any)  {
        guard phoneTextfield.text?.prefix(1) != nil else{
            return
        }
        guard let phoneText = phoneTextfield.text else{
            return
        }
        
        
        fullPhoneNum = phoneTextfield.text?.cleanMobileNumberFormat()
//        print(fullPhoneNum)
        
        if phoneTextfield.text?.prefix(1) == "0" && codeTextField.text?.last == "0"{
            
            phoneTextfield.text = replace(myString: phoneText, 0, " ").formatMobileNumber()
        }
            phoneTextfield.text = phoneTextfield.text?.formatMobileNumber()
        
    }
   
   
    @IBAction func goTovVrification(_ sender: UIButton) {
        //        let numberLabel = UILabel(frame: CGRect(x: 20, y: 20, width: 150, height: ))
        //        let messageLabel = UILabel(frame: CGRect(x: 20, y: 0, width: 150, height: 100))
        let suerAlert = UIAlertController(title: "\(code ?? "+20") \(phoneTextfield.text!)", message: "Press OK if your number is correct", preferredStyle: .alert)
        let alert = UIAlertController(title: "Please Make suer you enterd a phone Number", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let action = UIAlertAction(title: "OK", style: .default) { [self] action in
            let phoneNumber = "\(self.code ?? "+20") \(self.phoneTextfield.text!)"
            print(phoneNumber)
         
            PhoneAuthProvider.provider()
                .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] verificationID, error in
                    
                    guard let strongSelf = self else{
                        return
                    }
                    
                    if let error = error {

                        print("Error : \(error.localizedDescription)")
//                        let errorAlert = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
//                        errorAlert.addAction(cancel)
                        return
                    }
                    print("done")
                    UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                    UserDefaults.standard.set(strongSelf.fullPhoneNum, forKey: ids.uDPhoneNum)
                    performSegue(withIdentifier: "goToVerifcation", sender:  self)

                    // Sign in using the verificationID and the code sent to the user
                    // ...
                }
            
            
        }
        
        if phoneTextfield.text == "" {
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        }else{
            suerAlert.addAction(action)
            suerAlert.addAction(cancel)
            //            numberLabel.text = "\(code ?? "+20") \(phoneTextfield.text!)"
            //            messageLabel.text = "Your phone number is :"
            //            suerAlert.view.addSubview(numberLabel)
            //            suerAlert.view.addSubview(messageLabel)
            present(suerAlert, animated: true, completion: nil)
        }
        
        
        //        present(suerAlert, animated: true, completion: nil)
    }
    
    @objc func tapForCountery(){
        let story = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = story.instantiateViewController(withIdentifier: "CountryController") as? CountryController else {
            print("Error")
            return
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    func replace(myString: String, _ index: Int, _ newChar: String) -> String {
        var chars = Array(myString)     // gets an array of characters
        chars[index] = Character(newChar)
        let modifiedString = String(chars)
        return modifiedString
    }
    
    
}




extension String{
    func formatMobileNumber() -> String{
        
        let cleanPhoneNumber = components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        let mask = "XXX XXX XXXX"
        
        var result = ""
        var startIndex = cleanPhoneNumber.startIndex
        let endIndex = cleanPhoneNumber.endIndex
        for charct in mask where startIndex < endIndex {
            if charct == "X"{
                result.append(cleanPhoneNumber[startIndex])
                startIndex =  cleanPhoneNumber.index(after: startIndex)
                
                
            }else{
                result.append(charct)
            }
        }
        return result
    }
    
    func retriveformatMobileNumber() -> String{
        
        let cleanPhoneNumber = components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        let mask = "XXX XXX XXXXXXX"
        
        var result = ""
        var startIndex = cleanPhoneNumber.startIndex
        let endIndex = cleanPhoneNumber.endIndex
        for charct in mask where startIndex < endIndex {
            if charct == "X"{
                result.append(cleanPhoneNumber[startIndex])
                startIndex =  cleanPhoneNumber.index(after: startIndex)
                
                
            }else{
                result.append(charct)
            }
        }
        return result
    }
    
    func cleanMobileNumberFormat() -> String{
        replacingOccurrences(of: " ", with: "")
    }
}


