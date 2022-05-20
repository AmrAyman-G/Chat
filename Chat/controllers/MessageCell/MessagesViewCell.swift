//
//  MessagesViewCell.swift
//  Chat
//
//  Created by amr on 18/05/2022.
//

import UIKit

class MessagesViewCell: UITableViewCell {

    @IBOutlet weak var currentUserImage: UIImageView!
    @IBOutlet weak var currentUserMessage: UILabel!
    @IBOutlet weak var otherUserImage: UIImageView!
    @IBOutlet weak var OtherUserMessage: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
       
//        print(OtherUserMessage.text)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
