//
//  AddRecipeViewController.swift
//  RecipesApp
//
//  Created by Aaron Garman on 7/9/24.
//

import UIKit
import PhotosUI

class AddRecipeViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var prepTimeTextField: UITextField!
    @IBOutlet weak var attachPhotoButton: UIButton!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var directionsTextView: UITextView!
    
    var recipeToEdit: Recipe?
    var onAddRecipe: (() -> Void)? = nil
    var recipeImage: UIImage? // could possibly take this out?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.delegate = self // move these to below?
        prepTimeTextField.delegate = self
        directionsTextView.delegate = self
        
        styleUI()
        menuInit()
        checkIsEdit()
        gesturesInit()
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func didTapAddButton(_ sender: Any) {
        addRecipe()
    }
    
    func styleUI() {
        // maybe border on image? default image?
//        recipeImageView.layer.borderColor = UIColor.lightGray.cgColor
//        recipeImageView.layer.borderWidth = 1.0
        recipeImageView.layer.cornerRadius = 5.0 // decide value?
        
        // Add border to the UITextView - keep v make as rules in storyboard? sends warning in console?
        directionsTextView.layer.borderColor = UIColor.lightGray.cgColor
        directionsTextView.layer.borderWidth = 1.0
        directionsTextView.layer.cornerRadius = 5.0 // Optional, for rounded corners
    }
    
    func menuInit() {
        // keep "Choose an option"? title: "Choose an Option",
        // Choose from photos v diff?
        let menuItems = UIMenu(options: .displayInline, children: [
            UIAction(title: "Choose From Photos", image: UIImage(systemName: "photo"), handler: { _ in self.attachImage() }),
            UIAction(title: "Open Camera", image: UIImage(systemName: "camera"), handler: { _ in self.openCamera() })
        ])
        
        // Assign menu to button
        attachPhotoButton.menu = menuItems
        attachPhotoButton.showsMenuAsPrimaryAction = true  // Enables direct menu display when tapped
    }
    
    func checkIsEdit() { // name same as other?
        if let recipe = recipeToEdit {
            nameTextField.text = recipe.name
            prepTimeTextField.text = "\(recipe.prepTime)" // does this affect stuff w/ not string?
            recipeImageView.image = recipe.image
            directionsTextView.text = recipe.directions
            
            self.title = "Edit Recipe"
            addButton.title = "Done"
        }
    }
    
    func addRecipe() {
        guard let name = nameTextField.text,
              let prepTime = prepTimeTextField.text,
              let directions = directionsTextView.text,
              !name.isEmpty,
              !prepTime.isEmpty,
              !directions.isEmpty else {
            showEmptyFieldsAlert()
            return
        }
        
        guard let prepTimeNum = Int(prepTime), prepTimeNum > 0 else {
            showInvalidNumberAlert()
            return
        }

        var recipe = recipeToEdit ?? Recipe()
        recipe.name = name
        recipe.prepTime = prepTimeNum
        recipe.image = recipeImage ?? UIImage(named: "default-image") // change to pic once get - helper func for pic get?
        recipe.directions = directions
        
        saveRecipe()
    }
}

// photo picker & camera methods

extension AddRecipeViewController: PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // image picker methods
    
    func attachImage() {
        if PHPhotoLibrary.authorizationStatus(for: .readWrite) != .authorized {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
                switch status {
                case .authorized:
                    DispatchQueue.main.async {
                        self?.showImagePicker()
                    }
                default:
                    DispatchQueue.main.async {
                        self?.showGoToSettingsAlert()
                    }
                }
            }
        }
        else {
            showImagePicker()
        }
    }
    
    func showImagePicker() {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.filter = .images
        config.preferredAssetRepresentationMode = .current
        config.selectionLimit = 1

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let result = results.first
        
        guard let provider = result?.itemProvider,
              provider.canLoadObject(ofClass: UIImage.self) else { return }
        
        provider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            
            if let error = error {
                DispatchQueue.main.async { [weak self] in self?.showAlert(for:error) }
            }
            
            guard let image = object as? UIImage else { return }
            
            DispatchQueue.main.async { [weak self] in  // need to do dispatch? check lab example, need "?" after image? print above "image is valid" ? allows it to be updated on spot? dispactch since updating UI?
                self?.recipeImage = image
                self?.recipeImageView.image = image
            }
        }
    }
    
    // camera methods
    
    func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("Camera not available")
            return
        }

        let imagePicker = UIImagePickerController()
        
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("Unable to get image")
            return
        }
        // do i need dispatch queue here on in version w/ pick?
        recipeImage = image
        recipeImageView.image = image
    }
}

// Database operations - caps comments?

extension AddRecipeViewController {
    private func saveRecipe() {
        onAddRecipe?()
        dismiss(animated: true)
    }
}

// methods to control screen inputs

extension AddRecipeViewController { // any delegates move here?
    // do these as extension? and do conformance inheritance in it too
    
    // 2 print errors seen when clicking on input fields?
    
    func gesturesInit() {
        /*
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            directionsTextView.addGestureRecognizer(tapGesture)
        } */
    }
    
    // Implement the delegate method to handle the Return key press
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
/*
    // Implement the delegate method to handle the Return key press
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
*/
    // need? check options on storyboard?
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Check if the replacement text is the newline character
        if text == "\n" {
            // Add a newline character to the text view
            textView.text.append("\n")
            // Prevent the default behavior of the Return key
            return false
        }
        return true
    }
    
    // Dismiss the keyboard when the tap gesture is recognized - do one from lab 2 instead?
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// alerts methods

extension AddRecipeViewController {
    func showGoToSettingsAlert() { // titles caps or no?
        let alertController = UIAlertController (
            title: "Photo Access Required",
            message: "In order to upload a photo for a recipe, we need access to your photo library. You can allow access in Settings",
            preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        }

        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    } // need 2nd alert func? change anything?
    
    func showAlert(for error: Error? = nil) { // diff name? which funcs private v not?
        let alertController = UIAlertController(
            title: "Error",
            message: "\(error?.localizedDescription ?? "Please try again...")",
            preferredStyle: .alert)

        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)

        present(alertController, animated: true)
    }
    
    func showEmptyFieldsAlert() {
        let alertController = UIAlertController(
            title: "Error",
            message: "Name, Prep Time, and Directions fields must be filled out",
            preferredStyle: .alert) // caps need? just say all fields?

        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)

        present(alertController, animated: true)
    }
    
    func showInvalidNumberAlert() {
        let alertController = UIAlertController(
            title: "Error",
            message: "Prep time must be a valid number",
            preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)

        present(alertController, animated: true)
    }
}
