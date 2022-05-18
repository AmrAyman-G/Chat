//
//  MessageViewController.swift
//  Chat
//
//  Created by amr on 18/05/2022.
//

import UIKit

class MessageViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    
   
    
    
    

    @IBOutlet weak var tableView: UITableView!
    var array : [String] = ["1","2","3"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CurrentUserMessages.nib(), forCellReuseIdentifier: CurrentUserMessages.identfier)

        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrentUserMessages.identfier, for: indexPath) as! CurrentUserMessages
        cell.currentUserText.text = array[indexPath.row]
        return cell
    }

}
