//
//  LoginViewController.swift
//  examApp
//
//  Created by Plam Stefanova on 6/30/20.
//  Copyright © 2020 Plam Stefanova. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField:
    UITextField!
    
    @IBOutlet weak var passwordTextField:
    UITextField!
    
    @IBOutlet weak var errorLabel:
    UILabel!
    
    @IBOutlet weak var loginButton:
    UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginTapped(_ sender: Any){
        //validate fields
        
        //sign in the user
        signIn()
    }
    
    func signIn() {
        
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                self.errorLabel.text = "Couldn't sign in"
                self.errorLabel.alpha = 1
            }
            else {
                self.transitionToHome()
            }
        }
    }
    
    func transitionToHome(){
        let homeView = "HomeVC"
        let homeViewController = storyboard?.instantiateViewController(identifier: homeView)
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
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
