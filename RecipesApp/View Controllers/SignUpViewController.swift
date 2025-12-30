//
//  SignUpViewController.swift
//  RecipesApp
//
//  Created by Aaron Garman on 2/10/25.
//

import UIKit
import ParseSwift // need? check lab 2

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @IBAction func onViewTapped(_ sender: Any) {
        // Dismiss keyboard when tap off input boxes // caps on comments v no?
        view.endEditing(true)
    }
    
    @IBAction func onSignUpTapped(_ sender: Any) {
        signUp()
    }
    
    func signUp() {
        
        // make sure all fields are non-nil and non-empty
        
        guard let username = usernameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text,
              !username.isEmpty,
              !email.isEmpty,
              !password.isEmpty else {

            showMissingFieldsAlert()
            return
        }
        
        // create new user + save to db
        
        var newUser = User()
        
        newUser.username = username
        newUser.email = email
        newUser.password = password
        
        saveUser(newUser: newUser)
    }
    
    func saveUser(newUser: User) {
        newUser.signup { [weak self] result in

            switch result {
            case .success(let user):

                print("✅ Successfully signed up user \(user)")

                NotificationCenter.default.post(name: Notification.Name("signIn"), object: nil)

            case .failure(let error):
                self?.showSignUpErrorAlert(description: error.localizedDescription)
            }
        }
    }
}

// methods to control screen inputs

extension SignUpViewController: UITextFieldDelegate {
    // return key dismisses keyboard on text fields
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// error messages

extension SignUpViewController {
    func showSignUpErrorAlert(description: String?) {
         let alertController = UIAlertController(title: "Unable to Sign Up", message: description ?? "Unknown error", preferredStyle: .alert)
        
         let action = UIAlertAction(title: "OK", style: .default)
         alertController.addAction(action)
        
         present(alertController, animated: true)
     }

     func showMissingFieldsAlert() {
         let alertController = UIAlertController(title: "Error", message: "All fields must be filled out to sign in", preferredStyle: .alert)
         
         let action = UIAlertAction(title: "OK", style: .default)
         alertController.addAction(action)
         
         present(alertController, animated: true)
     }
}
