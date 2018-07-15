//
//  ViewController.swift
//  LockPass
//
//  Created by Nathan Lorenz on 2017-11-10.
//  Copyright © 2017 Nathan Lorenz. All rights reserved.
//

import UIKit
import CoreData
import LocalAuthentication


class ViewController: UIViewController, UITextFieldDelegate {
    
    
   
    
   
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func loginButton(_ sender: Any)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult> (entityName: "Password")
        
        request.returnsObjectsAsFaults = false
        
        do
        {
            
            let results = try context.fetch(request)
            for result in results as! [NSManagedObject]
            {
                if let thePassword = result.value(forKey: "password") as? String
                {
                    if passwordTextField.text == thePassword
                    {
                       performSegue(withIdentifier: "loggedIn", sender: self)
                    }
                    else
                    {
                        let alert = UIAlertController(title: "Incorrect Password", message: "The password you entered doesn't match our records, please try again.", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: self.clearBoxes)
                        alert.addAction(okAction)
                        
                        self.present(alert, animated: true, completion: nil)

                    }
                   
                    
                }
                
            }
            
        }
        catch
        {
            let alert = UIAlertController(title: "There was a error", message: "We encounterd a error, please try again.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    @IBAction func touchIDLogin(_ sender: Any)
    {
        let context:LAContext = LAContext()
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        {
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Use Touch ID to login", reply: { (wasSuccess, error) in
                if wasSuccess
                {
                    self.performSegue(withIdentifier: "loggedIn", sender: self)
                }
                else
                {
                    
                }
            })
        }
        else
        {
            let alert = UIAlertController(title: "Your device doesn't support Touch ID", message: nil, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    func clearBoxes(alert: UIAlertAction!)
    {
        passwordTextField.text = ""
    }
    
    
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var signInOutlet: UIButton!
    @IBOutlet weak var touchIDOutlet: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.hideKeyboard))
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        passwordTextField.inputAccessoryView = toolbar
        
        passwordTextField.delegate = self
        
        
        passwordView.layer.cornerRadius = 10
        signInOutlet.layer.cornerRadius = 5
        touchIDOutlet.layer.cornerRadius = 5
        
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                touchIDOutlet.setTitle("Use Touch ID", for: .normal)
            case 1334:
                touchIDOutlet.setTitle("Use Touch ID", for: .normal)
            case 2208:
                 touchIDOutlet.setTitle("Use Touch ID", for: .normal)
            case 2436:
                 touchIDOutlet.setTitle("Use Face ID", for: .normal)
            default:
                 touchIDOutlet.setTitle("Use Touch ID", for: .normal)
            }
        }
        
        let context:LAContext = LAContext()
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        {
            touchIDOutlet.isHidden = false
        }
        else
        {
            touchIDOutlet.isHidden = true
        }
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @objc func hideKeyboard()
    {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        passwordTextField.resignFirstResponder()
        return true
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        passwordTextField.text = ""
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult> (entityName: "Name")
        request.returnsObjectsAsFaults = false
        
        do
        {
            let results = try context.fetch(request)
            for result in results as! [NSManagedObject]
            {
                if let theName = result.value(forKey: "name") as? String
                {
                    welcomeLabel.text = "Welcome " + theName
                }
            }
        }
        catch
        {
            print("Error: Error in loading user's name.")
        }
        
    }

}

