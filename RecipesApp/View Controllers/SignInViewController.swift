//
//  SignInViewController.swift
//  RecipesApp
//
//  Created by Aaron Garman on 2/10/25.
//

import UIKit
import ParseSwift // need? check lab 2

class SignInViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func onViewTapped(_ sender: Any) {
        // Dismiss keyboard
        view.endEditing(true)
    }
    
    @IBAction func onSignInTapped(_ sender: Any) {
        signIn()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func signIn() {
        
        // make sure all fields are non-nil and non-empty
        
        guard let username = usernameTextField.text,
              let password = passwordTextField.text,
              !username.isEmpty,
              !password.isEmpty else {

            showMissingFieldsAlert()
            return
        }
        
        // log in user
        
        signInUser(username: username, password: password)
    }
    
    func signInUser(username: String, password: String) {
        User.login(username: username, password: password) { [weak self] result in

            switch result {
            case .success(let user):
                print("✅ Successfully logged in as user: \(user)")
                
                NotificationCenter.default.post(name: Notification.Name("signIn"), object: nil)

            case .failure(let error):
                self?.showSignInErrorAlert(description: error.localizedDescription)
            }
        }
    }
}

// methods to control screen inputs

extension SignInViewController: UITextFieldDelegate {
    // return key dismisses keyboard on text fields
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// error messages

extension SignInViewController {
    func showSignInErrorAlert(description: String?) {
        let alertController = UIAlertController(title: "Unable to Sign In", message: description ?? "Unknown error", preferredStyle: .alert)
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
