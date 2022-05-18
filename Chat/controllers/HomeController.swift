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

class HomeController: UITableViewController {
    
    var contacts = [Contacts]()
    let db = Firestore.firestore()
    let ids = IDs()
    var phoneNumber = [String]()
    
//    var dC = [DeviceContacts]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        tableView.register(CurrentUserMessages.nib(), forCellReuseIdentifier: CurrentUserMessages.identfier)
        
        getDevicePhoneNumber()
        
        
    }
    



    // MARK: - Table view data source
    

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }
    
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return phoneNumber.count
    }

    
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath)
            cell.textLabel?.text = phoneNumber[indexPath.row]
            cell.accessoryType = .disclosureIndicator
               
        return cell
    }
    
   
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "privetChat", sender: self)
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
