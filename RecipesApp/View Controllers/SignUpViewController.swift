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
    }
    
    @IBAction func onSignUpTapped(_ sender: Any) {
        signUp()
    }
    
    func signUp() {
        
        // Make sure all fields are non-nil and non-empty
        
        guard let username = usernameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text,
              !username.isEmpty,
              !email.isEmpty,
              !password.isEmpty else {

            showMissingFieldsAlert()
            return
        }
        
        var newUser = User()
        
        newUser.username = username
        newUser.email = email
        newUser.password = password

        newUser.signup { [weak self] result in

            switch result {
            case .success(let user):

                print("✅ Successfully signed up user \(user)")

                NotificationCenter.default.post(name: Notification.Name("signIn"), object: nil)

            case .failure(let error):
                self?.showAlert(description: error.localizedDescription)
            }
        }

    }

   func showAlert(description: String?) {
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

// make UI n actual outlets - test in step 1 directions
// abstract out to sign up func for action
