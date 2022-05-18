//
//  userChatCell.swift
//  Chat
//
//  Created by amr on 14/05/2022.
//

import UIKit

class CurrentUserMessages: UITableViewCell,UITableViewDelegate {

    @IBOutlet weak var currentUserText: UILabel!
    @IBOutlet weak var otherUserText: UILabel!
    
//    let hC = HomeController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        currentUserText.text = "123"
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
//    func configure(with contact:Contacts){
//        self.currentUserText.text = contact.phoneNumber
//    }
    
    
    static let identfier = "ChatGate"
    static func nib() -> UINib{
        return UINib(nibName: "ChatGate", bundle: nil)
    }
}
