//
//  ViewController.swift
//  Chat
//
//  Created by amr on 09/05/2022.
//

import UIKit
import FirebaseCore
import FirebaseAuth


          
      
class ViewController: UIViewController {
    

    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        var countries: [String] = []
//       print( ?? "no data")
       
            
        let currentUser = Auth.auth().currentUser?.phoneNumber
        if currentUser != nil{
            
           
                performSegue(withIdentifier: "currntUserStilIn", sender: self)
            
            
          
        }
    
        
        
//        for code in NSLocale.isoCountryCodes  {
//            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
//            let name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
//            countries.append(name)
//        }
//
//        print(countries)
    }
}
