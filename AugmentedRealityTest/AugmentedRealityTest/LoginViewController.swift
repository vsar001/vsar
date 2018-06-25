//
//  LoginViewController.swift
//  AugmentedRealityTest
//
//  Created by Semen Letychevskyy on 18.06.18.
//  Copyright © 2018 Anonymer Eintrag. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    
    @IBOutlet weak var testLebelLogIn: UILabel!
    
    @IBOutlet weak var logInEmailTextField: UITextField!
    
    @IBOutlet weak var logInPassTextField: UITextField!
    
    @IBAction func createUser(_ sender: UIButton) {
        if logInEmailTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().createUser(withEmail: logInEmailTextField.text!, password: logInPassTextField.text!) { (user, error) in
                if error == nil {
                    print("You have successfully register and signed up")
                    self.testLebelLogIn.text = "ok" //doesn't work, damn thing
                    //Auth.auth().signIn(withEmail: self.logInEmailTextField.text!, password: self.logInPassTextField.text!)
                    
                    //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
                    
                    //let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                    //self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        if logInEmailTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().signIn(withEmail: logInEmailTextField.text!, password: logInPassTextField.text!) { (user, error) in
                if error == nil {
                    print("You have successfully signed up")
                    self.testLebelLogIn.text = "ok" //doesn't work, damn thing
                    //Auth.auth().signIn(withEmail: self.logInEmailTextField.text!, password: self.logInPassTextField.text!)
                    
                    //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
                    
                    //let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                    //self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
     
     
     @IBAction func reg(_ sender: UIButton) {
     print("12345")
     
     }
     
     
    */

}
