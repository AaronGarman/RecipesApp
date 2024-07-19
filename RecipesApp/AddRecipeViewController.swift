//
//  AddRecipeViewController.swift
//  RecipesApp
//
//  Created by Aaron Garman on 7/9/24.
//

import UIKit

class AddRecipeViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var prepTimeTextField: UITextField!
    @IBOutlet weak var directionsTextView: UITextView!
    
    var onAddRecipe: ((Recipe) -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add border to the UITextView - keep v make as rules in storyboard? sends warning in console?
        directionsTextView.layer.borderColor = UIColor.black.cgColor
        directionsTextView.layer.borderWidth = 1.0
        directionsTextView.layer.cornerRadius = 5.0 // Optional, for rounded corners

        nameTextField.delegate = self
        prepTimeTextField.delegate = self
        directionsTextView.delegate = self
    /*
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        directionsTextView.addGestureRecognizer(tapGesture)
    } */
         
        // Do any additional setup after loading the view.
    }
    
    
    // do these as extension? and do conformance inheritance in it too
    
    // Implement the delegate method to handle the Return key press
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Implement the delegate method to handle the Return key press
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    // Dismiss the keyboard when the tap gesture is recognized
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // 2 print errors seen when clicking on input fields?
    
    @IBAction func didTapAddButton(_ sender: Any) {
        
        // still as int for time? numeric keyboard? work ok here?

        guard let name = nameTextField.text,
              let prepTime = prepTimeTextField.text,
              let directions = directionsTextView.text,
              !name.isEmpty,
              !prepTime.isEmpty,
              !directions.isEmpty else {
            showEmptyFieldsAlert()
            return
        }
        
        // maybe numeric later so no need this?
        guard let prepTimeNum = Int(prepTime) else {
            showNotNumberAlert()
            return
        }
        
        // change to pic once get - helper func for pic get?

        let recipe = Recipe(name: name, prepTime: prepTimeNum, image: UIImage(named: "pizza image"), directions: directions)
        onAddRecipe?(recipe)
        dismiss(animated: true)
    }
    
    private func showEmptyFieldsAlert() {
        let alertController = UIAlertController(
            title: "Error",
            message: "Name, Prep Time, and Directions fields must be filled out",
            preferredStyle: .alert) // caps need?

        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)

        present(alertController, animated: true)
    }

    private func showNotNumberAlert() {
        let alertController = UIAlertController(
            title: "Error",
            message: "Prep Time value must be a number",
            preferredStyle: .alert) // caps need? diff wording? or even need if numerical input force?

        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)

        present(alertController, animated: true)
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
