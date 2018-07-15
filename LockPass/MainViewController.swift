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

class MainViewController: UIViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
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
        searchBar.delegate = self
        
       
        
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
        
        let entity = NSEntityDescription.entity(forEntityName: "Items",
                                                in: managedContext)!
        
        let entity2 = NSEntityDescription.entity(forEntityName: "Email",
                                                in: managedContext)!
        
        let entity3 = NSEntityDescription.entity(forEntityName: "PasswordText",
                                                in: managedContext)!
        
        let entity4 = NSEntityDescription.entity(forEntityName: "Username",
                                                in: managedContext)!
        
        let theName = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
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
            print("saved")
            
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            
            let errorAlert = UIAlertController(title: "There was a error", message: "There was a error in trying to save your info, please try again", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            errorAlert.addAction(okAction)
            self.present(errorAlert, animated: true, completion: nil)
        }
        
       
        
        self.tableView.reloadData()
    
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchText != ""
        {
            var predicate: NSPredicate = NSPredicate()
            predicate = NSPredicate(format: "name contains[c]'\(searchText)'")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Items")
            fetchRequest.predicate = predicate
            do
            {
                titlename = try context.fetch(fetchRequest) as! [NSManagedObject]
            }
            catch
            {
                print("Could not get search data")
            }
        }
        else
        {
            searchBar.resignFirstResponder()
            
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
            catch
            {
                print("Could not reload data")
            }
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
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
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete
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
    

    
    @IBOutlet weak var infoButton: UIBarButtonItem!
    
    // Info button
    @IBAction func infoBt(_ sender: Any)
    {
        let infoAlert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let changePasswordAction = UIAlertAction(title: "Change Password", style: .destructive, handler: self.changepassword)
        let reportAProblem = UIAlertAction(title: "Report a Problem", style: .destructive, handler: self.reportAProblem)
        let logout = UIAlertAction(title: "Log Out", style: .default, handler: self.logout)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        infoAlert.addAction(changePasswordAction)
        infoAlert.addAction(reportAProblem)
        infoAlert.addAction(logout)
        infoAlert.addAction(cancel)
        self.present(infoAlert, animated: true, completion: nil)
        
    }
    
    //Functions for the info alert button
    // Change password button function
    
    var passwordTextField1: UITextField!
    var passwordTextField2: UITextField!
    
    func changepassword(alert: UIAlertAction!)
    {
        let passwordAlert = UIAlertController(title: "Change the Password", message: nil, preferredStyle: .alert)
        passwordAlert.addTextField(configurationHandler: passwordTextField1)
        passwordAlert.addTextField(configurationHandler: passwordTextField2)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: self.savePassword)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        passwordAlert.addAction(okAction)
        passwordAlert.addAction(cancelAction)
        self.present(passwordAlert, animated: true, completion: nil)
    }
    
    //TextField function
    func passwordTextField1(textField: UITextField!)
    {
        passwordTextField1 = textField
        passwordTextField1.placeholder = "New Password"
        passwordTextField1.isSecureTextEntry = true
    }
    func passwordTextField2(textField: UITextField!)
    {
        passwordTextField2 = textField
        passwordTextField2.placeholder = "Re-Enter New Password"
        passwordTextField2.isSecureTextEntry = true
    }
    
    //Save Button function
    func savePassword(alert: UIAlertAction!)
    {
        if passwordTextField1.text == passwordTextField2.text
        {
           let delegate = UIApplication.shared.delegate as! AppDelegate
            let context2 = delegate.persistentContainer.viewContext
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Password")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
            
        
            do
            {
                try context2.execute(deleteRequest)
                try context2.save()
                print("deleted")
            }
            catch
            {
                let alert2 = UIAlertController(title: "There was a error", message: "There was a error and the password couldn't be saved, please try again.", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert2.addAction(okButton)
                self.present(alert2, animated: true, completion: nil)
            }
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let password = NSEntityDescription.insertNewObject(forEntityName: "Password", into: context)
            password.setValue(passwordTextField2.text, forKey: "password")
            
            do
            {
                try context.save()
                print("saved")
            }
            catch
            {
                let alert2 = UIAlertController(title: "There was a error", message: "There was a error and the password couldn't be saved, please try again.", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert2.addAction(okButton)
                self.present(alert2, animated: true, completion: nil)
            }
            
        }
        else
        {
            let alert = UIAlertController(title: "Passwords don't match", message: "The passwords that you entered don't match, please try again.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: self.clearBoxes)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    func clearBoxes(alert: UIAlertAction!)
    {
        passwordTextField1.text = ""
        passwordTextField2.text = ""
    }
    
   
   
    //Logout button function
    func logout(alert: UIAlertAction!)
    {
        self.dismiss(animated: false, completion: nil)

    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController
    {
        let systemVersion = UIDevice.current.systemVersion
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        
        
        mailComposeVC.setToRecipients(["allswiftdeveloper@gmail.com"])
        mailComposeVC.setSubject("Reported Problem - Lock Pass")
        mailComposeVC.setMessageBody("System Information\n\n iOS \(systemVersion) \n Version 1.0.0 \n\n Hi Team!\n\n", isHTML: false)
        
        return mailComposeVC
    }
    
    func showSendMailErrorAlert()
    {
        let alert = UIAlertController(title: "Could not Send Mail", message: "Unable to send email. Please check your email configuration, and try again.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
        switch result {
        case MFMailComposeResult.cancelled:
            self.dismiss(animated: true, completion: nil)
        case MFMailComposeResult.failed:
            self.showSendMailErrorAlert()
            self.dismiss(animated: true, completion: nil)
        case MFMailComposeResult.sent:
            self.dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
    
    //Report a problem function
    func reportAProblem(alert: UIAlertAction!)
    {
        let mailComposeViewController = configuredMailComposeViewController()
        
        if MFMailComposeViewController.canSendMail()
        {
            self.present(mailComposeViewController, animated: true)
        }
        else
        {
            self.showSendMailErrorAlert()
        }
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
        let cell =
            tableView.dequeueReusableCell(withIdentifier: "cell",
                                          for: indexPath)
        cell.textLabel?.text =
            name.value(forKeyPath: "name") as? String
        return cell
        
    }
    
    
    
    
}
