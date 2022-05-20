//
//  MessageViewController.swift
//  Chat
//
//  Created by amr on 18/05/2022.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth




class MessageViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //MARK: - Outlets & Varibels & constans
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendMessageTextField: UITextField!
    let ids = IDs()
    let db = Firestore.firestore()
    let currentUser = UserDefaults.standard.string(forKey: "phoneNum")
    let targetUser = UserDefaults.standard.string(forKey: "UserFriend")
    var Messages = [MessagesBody]()
    
    
    
    
    
    //MARK: - ViewDidLoad-
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "MessagesViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MessagesViewCell")
        loadData()
    }
    
    
    
    
    
    //MARK: - IBActions (Buttons)
    @IBAction func textChanged(_ sender: UITextField) {
        //       print( sendMessageTextField.text)
        
    }
    
    @IBAction func sendMessageButton(_ sender: UIButton) {
        if sendMessageTextField.text != "" {
            saveData()
            DispatchQueue.main.async{
                self.sendMessageTextField.text = ""
            }
        }
    }
    
    
    
    //MARK: - (Save & Load) Data -
    
    func saveData(){
        
        if let currentPhone = currentUser, let messages = sendMessageTextField.text, let targetUser = UserDefaults.standard.string(forKey: "UserFriend"){
            db.collection("SMessages").addDocument(data: [
                "Body"  : messages,
                "Sender": currentPhone,
                "Resiver": targetUser,
                "Time"  : Date().timeIntervalSince1970
            ]){ error in
                if error != nil {
                    print(error?.localizedDescription ?? "no error")
                }
            }
        }
    }
    
    //MARK: --
    
    func loadData(){
        
       
            db.collection("SMessages").order(by: "Time", descending: false).addSnapshotListener {[weak self] (querySnapshot, error)  in
                guard let strongSelf = self else{
                    return
                }
                
                strongSelf.Messages = []
                print("inside: \(strongSelf.Messages.count)")
                
                if error != nil {
                    print(error?.localizedDescription ?? "error!")
                }else{
                    if let documentsData = querySnapshot?.documents{
                        for doc in documentsData{
                            let data = doc.data()
                            if let messageBody = data["Body"] as? String , let time = data["Time"], let sender = data["Sender"] as? String, let resiver = data["Resiver"] as? String{
                                
                                let messagesBody = MessagesBody(body: messageBody,
                                                                time: strongSelf.timeFormater(with: time),
                                                                sender: sender, resiver: resiver)
                               
                                strongSelf.Messages.append(messagesBody)
                                print("Messages: \(strongSelf.Messages.count)")
                                
                                DispatchQueue.main.async {
                                    strongSelf.tableView.reloadData()
                                    let indexPath = IndexPath(row: strongSelf.Messages.count - 1, section: 0)
                                    strongSelf.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                                }
                                
                                
                            }
                        }
                        
                    }
                }
                print("out: \(strongSelf.Messages.count)")
            }
    }
        
        
        
        
        
        
        
   
    
    
    
    //MARK: - Other Functions -
    
    
    func timeFormater(with time:Any) -> String{
        let timeResult = time
        let date = Date(timeIntervalSince1970: timeResult as! TimeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date)
        return localDate
    }
 
    
    
}

//MARK: - TebleVeiew Functions -
extension MessageViewController
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessagesViewCell", for: indexPath) as! MessagesViewCell
        print("all messages: \(Messages[indexPath.row].sender)")
        if currentUser == Messages[indexPath.row].sender && targetUser == Messages[indexPath.row].resiver {
            cell.currentUserMessage.text = Messages[indexPath.row].body
            cell.OtherUserMessage.isHidden = true
            cell.currentUserMessage.isHidden = false
//            print("currentUser: \(messages[indexPath.row].sender)")
            
        }else if targetUser == Messages[indexPath.row].sender{
            cell.OtherUserMessage.text = Messages[indexPath.row].body
            cell.OtherUserMessage.isHidden = false
            cell.currentUserMessage.isHidden = true
            print("TargetUser: \(Messages[indexPath.row].sender)")
        }
            
        return cell
    }
}



