//
//  HomeController.swift
//  Chat
//
//  Created by amr on 08/05/2022.
//

import UIKit
import Contacts
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

protocol passData{
    func getData(num:String)
}

class HomeController: UITableViewController {
   
    
    
    
    
    
    var contacts = [Contacts]()
    let db = Firestore.firestore()
    let ids = IDs()
    var phoneNumber = [String]()
    var phone: String?
    var delegate:passData?
    var message: [newMessage] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        let nib = UINib(nibName: "UserCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "UserCell")
        getDevicePhoneNumber()
        resivedMessage()
    }
    



    // MARK: - Table view data source
    

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }
    
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return phoneNumber.count
    }

    
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
            cell.cellName.text = phoneNumber[indexPath.row]
            cell.cellMessage.text = message[indexPath.row].body
            cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         //optional, to get from any UIButton for example
        
        let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        if let selectedUser = currentCell.textLabel?.text{
            UserDefaults.standard.set(selectedUser, forKey: "UserFriend") 
        }
//        print("PHONE : \(phone)")
        if let uRPhone = phone{delegate?.getData(num: uRPhone)}
        
        
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "privetChat", sender: self)
    }
   
   
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
//    {
//    if segue.destination is MessageViewController {
//    let vc = segue.destination as? MessageViewController
//        vc?.freindNum = value
//    }
//    }
    
    func resivedMessage(){
        db.collection("SMessages").order(by: "Time", descending: true).getDocuments { snapshot, error in
            if  let document = snapshot?.documents{
                for doc in document {
                    let data = doc.data()
                    if let body = data["Body"]  as? String {
                        let messageB = newMessage(body: body)
                        self.message.append(messageB)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
           
        }
    }
    
    func getDevicePhoneNumber(){
        let keys = [CNContactGivenNameKey, CNContactPhoneNumbersKey,CNContactFamilyNameKey,CNContactEmailAddressesKey] as [CNKeyDescriptor]
           let request = CNContactFetchRequest(keysToFetch: keys)
           
           let contactStore = CNContactStore()
           do {
               try contactStore.enumerateContacts(with: request) {[weak self]
                   (contact, stop) in
                   
                   guard let strongSelf = self else {
                       return
                   }
                   
                   guard let number = contact.phoneNumbers.first?.value.stringValue else {
                       return
                   }
                   let fullName = contact.givenName
                   // Array containing all unified contacts from everywhere
                   let contactsToAppend = Contacts(phoneNumber: number, name: fullName)
                   strongSelf.contacts.append(contactsToAppend)
                   if Auth.auth().currentUser?.phoneNumber == contact.phoneNumbers.first?.value.stringValue {
//                       print(Auth.auth().currentUser?.phoneNumber)
                   }
                   
                   strongSelf.db.collection(strongSelf.ids.userProfile).getDocuments {[weak self] snapShot, error in
                       guard let strongSelf = self else {
                           return
                       }
                       for doc in snapShot!.documents{
                           if contact.phoneNumbers.first?.value.stringValue.cleanMobileNumberFormat() == doc[strongSelf.ids.currentUserByPhone] as? String && contact.phoneNumbers.first?.value.stringValue.cleanMobileNumberFormat() != UserDefaults.standard.string(forKey: strongSelf.ids.uDPhoneNum) {
                               strongSelf.phoneNumber.append(doc[strongSelf.ids.currentUserByPhone] as! String)
                               print("If Worked : \(strongSelf.phoneNumber)")
                               strongSelf.tableView.reloadData()
                           }else{
                               print("Shit")
                           }
                       }
                   }
               }
           }
           catch {
               print("unable to fetch contacts")
           }
    }
}
