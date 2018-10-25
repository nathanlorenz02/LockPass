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
    }
    
    @IBAction func goBackLogin(_ sender: Any)
    {
        if passwordTextField1.text == passwordTextField2.text
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let context = appDelegate.persistentContainer.viewContext
            
            let password = NSEntityDescription.insertNewObject(forEntityName: "Password", into: context)
            let name = NSEntityDescription.insertNewObject(forEntityName: "Name", into: context)
            
            password.setValue(passwordTextField2.text, forKey: "password")
            name.setValue(nameTextField.text, forKey: "name")
            
            do
            {
                try context.save()
                print("saved")
            }
            catch
            {
                let alert2 = UIAlertController(title: "There was a error", message: "There was a error and the password couldn't be saved.", preferredStyle: .alert)
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
