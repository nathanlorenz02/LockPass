//
//  ItemInfoViewController.swift
//  LockPass
//
//  Created by Nathan Lorenz on 2018-03-22.
//  Copyright © 2018 Nathan Lorenz. All rights reserved.
//

import UIKit
import CoreData

class ItemInfoViewController: UIViewController {
    
    
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    var name = ""
    var email = ""
    var password = ""
    var username = ""
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        infoView.layer.cornerRadius = 5
        
        nameLabel.text = name
        emailLabel.text = email
        passwordLabel.text = password
        usernameLabel.text = username
        

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    @IBAction func dismissButton(_ sender: UIButton)
    {
        dismiss(animated: true, completion: nil)

    }
    

}
