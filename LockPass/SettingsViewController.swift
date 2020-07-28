//
//  SettingsViewController.swift
//  LockPass
//
//  Created by Nathan Lorenz on 2018-10-30.
//  Copyright © 2018 Nathan Lorenz. All rights reserved.
//

import UIKit
import CoreData
import MessageUI
import LocalAuthentication

class SettingsViewController: UIViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var reportAProblemButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var prioritizeAuthSwitch: UISwitch!
    @IBOutlet weak var prioritizeAuthLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       self.navigationController?.navigationBar.prefersLargeTitles = true
        
        changePasswordButton.layer.cornerRadius = 7
        reportAProblemButton.layer.cornerRadius = 7
        logOutButton.layer.cornerRadius = 7
        
        checkforFaceORTouchID()
       
    }
    
    
    @IBAction func changePassword(_ sender: UIButton)
    {
        let context:LAContext = LAContext()
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        {
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Use Touch ID/Face ID to login", reply: { (wasSuccess, error) in
                if wasSuccess
                {
                    let passwordAlert = UIAlertController(title: "Change the Password", message: nil, preferredStyle: .alert)
                    passwordAlert.addTextField(configurationHandler: self.passwordTextField1)
                    passwordAlert.addTextField(configurationHandler: self.passwordTextField2)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: self.savePassword)
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    passwordAlert.addAction(okAction)
                    passwordAlert.addAction(cancelAction)
                    self.present(passwordAlert, animated: true, completion: nil)
                    
                }
                else
                {
                    let passwordAlert = UIAlertController(title: "Enter The Old Password", message: nil, preferredStyle: .alert)
                    passwordAlert.addTextField(configurationHandler: self.oldPasswordTextField)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: self.checkOldPassword)
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    passwordAlert.addAction(okAction)
                    passwordAlert.addAction(cancelAction)
                    self.present(passwordAlert, animated: true, completion: nil)
                }
            })
        }
        else
        {
            let passwordAlert = UIAlertController(title: "Enter The Old Password", message: nil, preferredStyle: .alert)
            passwordAlert.addTextField(configurationHandler: self.oldPasswordTextField)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: self.checkOldPassword)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            passwordAlert.addAction(okAction)
            passwordAlert.addAction(cancelAction)
            self.present(passwordAlert, animated: true, completion: nil)
        }
    }
    
    var oldPasswordTextField: UITextField!
    var passwordTextField1: UITextField!
    var passwordTextField2: UITextField!
    
    //TextField function
    func oldPasswordTextField(textfield: UITextField!)
    {
        oldPasswordTextField = textfield
        oldPasswordTextField.placeholder = "Old Password"
        oldPasswordTextField.isSecureTextEntry = true
    }
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
    
    
    func checkOldPassword(alert: UIAlertAction!)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let oldPassFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Password")
        do
        {
            let results = try context.fetch(oldPassFetch)
            for result in results as! [NSManagedObject]
            {
                if let theOldPassword = result.value(forKey: "password") as? String
                {
                    if oldPasswordTextField.text == theOldPassword
                    {
                        let passwordAlert = UIAlertController(title: "Change the Password", message: nil, preferredStyle: .alert)
                        passwordAlert.addTextField(configurationHandler: self.passwordTextField1)
                        passwordAlert.addTextField(configurationHandler: self.passwordTextField2)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: self.savePassword)
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                        passwordAlert.addAction(okAction)
                        passwordAlert.addAction(cancelAction)
                        self.present(passwordAlert, animated: true, completion: nil)
                    }
                    else
                    {
                        let alert = UIAlertController(title: "Password doesn't match", message: "The password that you entered doesn't match, please try again.", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: self.clearBoxes)
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
        catch
        {
            print("Unable to get old password")
        }
    }
        
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
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: self.clearBoxes)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func clearBoxes(alert: UIAlertAction!)
    {
        passwordTextField1.text = ""
        passwordTextField2.text = ""
    }
    
    
    
    @IBAction func reportAProblem(_ sender: UIButton)
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
        let alert = UIAlertController(title: "Could not Send Mail", message: "Unable to send email. Please check your email configuration, and try again.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
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
    
    func checkforFaceORTouchID()
    {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                prioritizeAuthLabel.text = "Prioritize Touch ID"
            case 1334:
                prioritizeAuthLabel.text = "Prioritize Touch ID"
            case 2208:
                prioritizeAuthLabel.text = "Prioritize Touch ID"
            case 2436:
                prioritizeAuthLabel.text = "Prioritize Face ID"
            case 1792:
                prioritizeAuthLabel.text = "Prioritize Face ID"
            case 2688:
                prioritizeAuthLabel.text = "Prioritize Face ID"
            default:
                prioritizeAuthLabel.text = "Prioritize Face ID"
            }
        }
        if UIDevice().userInterfaceIdiom == .pad {
            switch UIScreen.main.nativeBounds.height
            {
            case 2388:
                prioritizeAuthLabel.text = "Prioritize Face ID"
            case 2732:
                prioritizeAuthLabel.text = "Prioritize Face ID"
            default:
                prioritizeAuthLabel.text = "Prioritize Touch ID"
            }
        }
        
        let context:LAContext = LAContext()
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        {
            prioritizeAuthSwitch.isHidden = false
            prioritizeAuthLabel.isHidden = false
        }
        else
        {
           prioritizeAuthSwitch.isHidden = true
           prioritizeAuthLabel.isHidden = true
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let checkContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AuthPriority")
        request.returnsObjectsAsFaults = false
        do
        {
            let results = try checkContext.fetch(request)
            for result in results as! [NSManagedObject]
            {
                if let theAuthPriority = result.value(forKey: "authPriority") as? Bool
                {
                    if theAuthPriority == true
                    {
                        prioritizeAuthSwitch.isOn = true
                    }
                    else
                    {
                        prioritizeAuthSwitch.isOn = false
                    }
                }
            }
        }
        catch
        {
            print("Unable to return authentication priority")
        }
        
        
    }
    
    
    @IBAction func priorityAuthChange(_ sender: Any)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        if prioritizeAuthSwitch.isOn == true
        {
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "AuthPriority")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
            do
            {
                try context.execute(deleteRequest)
                try context.save()
            }
            catch
            {
                print("Unable to delete auth priority request")
            }
            let prioritizeAuth = NSEntityDescription.insertNewObject(forEntityName: "AuthPriority", into: context)
            prioritizeAuth.setValue(true, forKey: "authPriority")
            do
            {
                try context.save()
            }
            catch
            {
                print("Unable to save auth priority request")
            }
        }
        else
        {
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "AuthPriority")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
            do
            {
                try context.execute(deleteRequest)
                try context.save()
            }
            catch
            {
                print("Unable to delete auth priority request")
            }
            let prioritizeAuth = NSEntityDescription.insertNewObject(forEntityName: "AuthPriority", into: context)
            prioritizeAuth.setValue(false, forKey: "authPriority")
            do
            {
                try context.save()
            }
            catch
            {
                print("Unable to save auth priority request")
            }
        }
    }
    
 

  

}
