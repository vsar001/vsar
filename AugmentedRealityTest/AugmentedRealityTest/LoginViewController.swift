//
//  LoginViewController.swift
//  AugmentedRealityTest
//
//  Created by Semen Letychevskyy on 18.06.18.
//  Copyright © 2018 Anonymer Eintrag. All rights reserved.
//

import UIKit
import FirebaseAuth

typealias fbUser = FirebaseAuth.User
//Password mindestens 6 zeichen!

class LoginViewController: UIViewController {
    
    @IBAction func backDoor(_ sender: UIButton) {
        self.performSegue(withIdentifier: "createUserSuccess", sender:sender)
    }
    
    @IBOutlet weak var userNameTextField: UITextField!
    
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
                    DispatchQueue.main.async{
                        let currentUser = Auth.auth().currentUser
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.displayName = self.userNameTextField.text
                        changeRequest?.commitChanges(completion: { (error) in
                            if let error = error {
                                print(error.localizedDescription)
                                
                            }
                        })
                        print("You have successfully register and signed up")
                    }
                    self.performSegue(withIdentifier: "createUserSuccess", sender:sender)
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBOutlet weak var signInLogin: UITextField!
    @IBOutlet weak var signInPass: UITextField!
    
    @IBAction func signIn(_ sender: UIButton) {
        if signInLogin.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().signIn(withEmail: signInLogin.text!, password: signInPass.text!) { (user, error) in
                if error == nil {
                    DispatchQueue.main.async{
                    print("You have successfully signed up")
                        } 
                    self.performSegue(withIdentifier: "signInSuccess", sender:sender)
                    
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
     
    */

}
