//
//  LoginViewController.swift
//  Parstagram
//
//  Created by Akarsh Kumar on 3/9/19.
//  Copyright © 2019 Akarsh Kumar. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signInClicked(_ sender: Any) {
        PFUser.logInWithUsername(inBackground: usernameTextField.text!, password: passwordTextField.text!) { (user, error) in
            if user != nil {
                print("success")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                print("error")
            }
        }

    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        let user = PFUser()
        user.username = usernameTextField.text
        user.password = passwordTextField.text
        //user.email = "email@example.com"
        // other fields can be set just like with PFObject
        //user["phone"] = "415-392-0202"
        
        user.signUpInBackground { (success, error) in
            if(success){
                print("success");
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
            else {
                print("error");
            }
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
