//
//  CreateAccountViewController.swift
//  LockPass
//
//  Created by Nathan Lorenz on 2017-11-10.
//  Copyright © 2017 All Work Software. All rights reserved.
//

import UIKit
import CoreData

class CreateAccountViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var passwordTextField1: UITextField!
    @IBOutlet weak var passwordTextField2: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var saveOutet: UIButton!
    

    @objc func hideKeyboard()
    {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        passwordTextField1.resignFirstResponder()
        passwordTextField2.resignFirstResponder()
        nameTextField.resignFirstResponder()
        return true
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.hideKeyboard))
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        passwordTextField1.inputAccessoryView = toolbar
        passwordTextField2.inputAccessoryView = toolbar
        nameTextField.inputAccessoryView = toolbar
        
        passwordTextField1.delegate = self
        passwordTextField2.delegate = self
        nameTextField.delegate = self
        
        passwordView.layer.cornerRadius = 10
        saveOutet.layer.cornerRadius = 5
        
        // Move view up for space for keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver((self), selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height / 2
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @IBAction func goBackLogin(_ sender: Any)
    {
        if nameTextField.text != nil
        {
            if passwordTextField1!.text == nil || passwordTextField2.text == nil
            {
                let alert = UIAlertController(title: "You didn't add a password", message: "To ensure maximum safety of your passwords, please choose a password to begin.", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okButton)
                alert.present(alert, animated: true, completion: nil)
            }
            else
            {
                if passwordTextField1.text == passwordTextField2.text
                {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    
                    let context = appDelegate.persistentContainer.viewContext
                    
                    let password = NSEntityDescription.insertNewObject(forEntityName: "Password", into: context)
                    let name = NSEntityDescription.insertNewObject(forEntityName: "Name", into: context)
                    let prioritizeAuth = NSEntityDescription.insertNewObject(forEntityName: "AuthPriority", into: context)
                    
                    password.setValue(passwordTextField2.text, forKey: "password")
                    name.setValue(nameTextField.text, forKey: "name")
                    prioritizeAuth.setValue(false, forKey: "authPriority")
                    
                    do
                    {
                        try context.save()
                    }
                    catch
                    {
                        let alert2 = UIAlertController(title: "There was a error", message: "There was a error and the password or other data couldn't be saved.", preferredStyle: .alert)
                        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert2.addAction(okButton)
                        self.present(alert2, animated: true, completion: nil)
                    }
                    
                    performSegue(withIdentifier: "gotUser", sender: self)
                }
                else
                {
                    let alert = UIAlertController(title: "Passwords don't match", message: "The passwords that you entered don't match, please try again.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: self.clearBoxes)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        
        }
        else
        {
            let alert = UIAlertController(title: "Fields Not Filled In Correctly", message: "Please make sure all the fields are filled in correctly", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
    }
    func clearBoxes(alert: UIAlertAction!)
    {
        passwordTextField1.text = ""
        passwordTextField2.text = ""
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
