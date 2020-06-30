//
//  SignUpViewController.swift
//  examApp
//
//  Created by Plam Stefanova on 6/30/20.
//  Copyright © 2020 Plam Stefanova. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField:
    UITextField!
    @IBOutlet weak var emailTextField:
    UITextField!
    @IBOutlet weak var passwordTextField:
    UITextField!
    
    @IBOutlet weak var signUpButton:
    UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpTapped(_ sender: Any){
        setUpElements()
        //Validate the fields
        let error = validateFields()
        
        if error != nil {
            //there something wrong with the fields, show error message
            showError(error!)
        }
        
        else {
        //create cleaned versions of the data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                    //check for errors
                if err != nil {
                    //there was an error creating the user
                    self.showError("Error creating user")
                    //print(err?.localizedDescription)
                }
                else {
                    //user was created sucessfully, now store first and last name
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data: ["firstname":firstName,"lastname":lastName,"uid": result!.user.uid]) { (error) in
                        if error != nil {
                            self.showError("User data couldnt be saved properly")
                        }
                    }
                    //Transition to the home screen
                    self.transitionToHome()
                }
            }
            
            
            }
    }
    
    func transitionToHome(){
        let homeView = "HomeVC"
        let homeViewController = storyboard?.instantiateViewController(identifier: homeView)
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
    func showError(_ message:String){
        errorLabel.text = message
        errorLabel.alpha = 1
        
    }
        
    
    func setUpElements(){
        //hide the error label
        errorLabel.alpha = 0
        
    }
   
     //check the fields and validate the data. If everything is correct return nil, else return error message
    func validateFields () -> String? {
       
        //check that all fields are flled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Please fill in all fields"
        }
        
        //check if the password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if !isPasswordValid(cleanedPassword){
            return "Please make sure your password is Minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet and 1 Number"
        }
        
        return nil
    }
    
    func isPasswordValid(_ password: String) -> Bool{
        //Minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet and 1 Number:
        let passwordTest = NSPredicate(format: "SELF MATCHES %@","^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$")
        return passwordTest.evaluate(with: password)
    }
    
}
