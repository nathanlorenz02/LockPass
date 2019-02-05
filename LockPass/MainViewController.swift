//
//  MainViewController.swift
//  LockPass
//
//  Created by Nathan Lorenz on 2017-11-10.
//  Copyright © 2017 All Work Software. All rights reserved.
//

import UIKit
import CoreData
import MessageUI
import UserNotifications

var titlename: [NSManagedObject] = []
var emailname: [NSManagedObject] = []
var passwordname: [NSManagedObject] = []
var username: [NSManagedObject] = []

class MainViewController: UIViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        } else {
           
        }
        
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
        if didAllow
        {
                
        }
        else
        {
                
        }
            
        })
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
       
        
        //January 1 notification
        var dateComponents = DateComponents()
        dateComponents.hour = 9
        dateComponents.minute = 00
        dateComponents.month = 1
        dateComponents.day = 1
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        

        
        let content = UNMutableNotificationContent()
        content.body =  "Remember to update your passwords often to keep maxium security!"
        
        let request = UNNotificationRequest(
            identifier: "notfication", content: content, trigger: trigger
        )
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        //June 30 notifcation
        var dateComponents2 = DateComponents()
        dateComponents2.hour = 9
        dateComponents2.minute = 00
        dateComponents2.month = 6
        dateComponents2.day = 30
        
        let trigger2 = UNCalendarNotificationTrigger(dateMatching: dateComponents2, repeats: true)
        
        
        
        let content2 = UNMutableNotificationContent()
        content.body =  "Remember to update your passwords often to keep maxium security!"
        
        let request2 = UNNotificationRequest(
            identifier: "notfication2", content: content2, trigger: trigger2
        )
        UNUserNotificationCenter.current().add(request2, withCompletionHandler: nil)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        loadAllTableData()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    var nameTextField: UITextField!
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    var userNameTextField: UITextField!
    
    func nameTextField(textfield: UITextField!)
    {
        nameTextField = textfield
        nameTextField.placeholder = "Item Name (i.e. Facebook)"
        nameTextField.autocapitalizationType = .words
    }
    func emailTextField(textfield: UITextField!)
    {
        emailTextField = textfield
        self.emailTextField.keyboardType = UIKeyboardType.emailAddress
        emailTextField.placeholder = "Email (i.e. someone@icloud.com)"
    }
    func passwordTextField(textfield: UITextField!)
    {
        passwordTextField = textfield
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
    }
    func userNameTextField(textfield: UITextField!)
    {
        userNameTextField = textfield
        userNameTextField.placeholder = "Username(Optional)"
    }
    
    @IBAction func addItem(_ sender: Any)
    {
        let alert = UIAlertController(title: "Enter Your Credinals",
                                      message: nil,
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: self.save)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField(configurationHandler: nameTextField)
        alert.addTextField(configurationHandler: emailTextField)
        alert.addTextField(configurationHandler: passwordTextField)
        alert.addTextField(configurationHandler: userNameTextField)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
        
    }
    
    func save(alert: UIAlertAction!)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Items", in: managedContext)!
        let entity2 = NSEntityDescription.entity(forEntityName: "Email", in: managedContext)!
        let entity3 = NSEntityDescription.entity(forEntityName: "PasswordText", in: managedContext)!
        let entity4 = NSEntityDescription.entity(forEntityName: "Username", in: managedContext)!
        let theName = NSManagedObject(entity: entity, insertInto: managedContext)
        let theEmail = NSManagedObject(entity: entity2, insertInto: managedContext)
        let thePassword = NSManagedObject(entity: entity3, insertInto: managedContext)
        let theUsername = NSManagedObject(entity: entity4, insertInto: managedContext)
        theName.setValue(nameTextField.text, forKeyPath: "name")
        theEmail.setValue(emailTextField.text, forKey: "email")
        thePassword.setValue(passwordTextField.text, forKey: "password")
        theUsername.setValue(userNameTextField.text, forKey: "username")
        do
        {
            try managedContext.save()
            titlename.append(theName)
            emailname.append(theEmail)
            passwordname.append(thePassword)
            username.append(theUsername)
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            let errorAlert = UIAlertController(title: "There was a error", message: "There was a error in trying to save your info, please try again", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            errorAlert.addAction(okAction)
            self.present(errorAlert, animated: true, completion: nil)
        }
        
        self.tableView.reloadData()
    
    }
    
    
    func loadAllTableData()
    {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Items")
        let fetchRequest2 =
            NSFetchRequest<NSManagedObject>(entityName: "Email")
        let fetchRequest3 =
            NSFetchRequest<NSManagedObject>(entityName: "PasswordText")
        let fetchRequest4 =
            NSFetchRequest<NSManagedObject>(entityName: "Username")
        
        do
        {
            titlename = try managedContext.fetch(fetchRequest)
            emailname = try managedContext.fetch(fetchRequest2)
            passwordname = try managedContext.fetch(fetchRequest3)
            username = try managedContext.fetch(fetchRequest4)
            
        }
        catch let error as NSError
        {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        tableView.reloadData()
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        var name2 = String()
        var email2 = String()
        var password2 = String()
        var username2 = String()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let name = titlename[indexPath.row]
        name2 = (name.value(forKeyPath: "name") as? String)!
        
        
        let email = emailname[indexPath.row]
        email2 = (email.value(forKey: "email") as? String)!
        
        let password = passwordname[indexPath.row]
        password2 = (password.value(forKey: "password") as? String)!
        
        let usernameThing = username[indexPath.row]
        username2 = (usernameThing.value(forKey: "username") as? String)!
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let infoVC = storyboard.instantiateViewController(withIdentifier: "showInfo") as! ItemInfoViewController
        infoVC.name = name2
        infoVC.email = email2
        infoVC.password = password2
        infoVC.username = username2
        self.present(infoVC, animated: true, completion: nil)
       

    }
    
   
    
    
    //Delete data
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCell.EditingStyle.delete
        {
            
          
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            context.delete(titlename[indexPath.row])
            context.delete(emailname[indexPath.row])
            context.delete(passwordname[indexPath.row])
            context.delete(username[indexPath.row])
            
            titlename.remove(at: indexPath.row)
            emailname.remove(at: indexPath.row)
            passwordname.remove(at: indexPath.row)
            username.remove(at: indexPath.row)
            
            do
            {
                try context.save()
            }
            catch
            {
                print("Error: There was a error in deleteing")
            }

            tableView.reloadData()
        }
    }
    
    //Logout button function
    func logout(alert: UIAlertAction!)
    {
        self.dismiss(animated: false, completion: nil)

    }
    
    
    
    
}

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       return titlename.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let name = titlename[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = name.value(forKeyPath: "name") as? String
        return cell
        
    }
    
    
    
    
}
