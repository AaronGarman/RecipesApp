//
//  AddRecipeViewController.swift
//  RecipesApp
//
//  Created by Aaron Garman on 7/9/24.
//

import UIKit
import PhotosUI
import ParseSwift
import Alamofire
import AlamofireImage // need? other places too?

class AddRecipeViewController: UIViewController {

    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var prepTimeTextField: UITextField!
    @IBOutlet weak var attachPhotoButton: UIButton!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var directionsTextView: UITextView!
    
    var recipeToEdit: Recipe?
    var onAddRecipe: (() -> Void)? = nil
    var recipeImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.delegate = self
        prepTimeTextField.delegate = self
        
        styleUI()
        menuInit()
        checkIsEdit()
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
            directionsTextView.text = recipe.directions
            
            if let imageFile = recipe.imageFile,
               let imageUrl = imageFile.url {
                
                // Use AlamofireImage helper to fetch remote image from URL
                AF.request(imageUrl).responseImage { [weak self] response in
                    switch response.result {
                    case .success(let image):
                        self?.recipeImage = image
                        self?.recipeImageView.image = image
                    case .failure(let error):
                        print("Error fetching image: \(error.localizedDescription)")
                        break
                    }
                }
            }
            
            self.title = "Edit Recipe"
            addButton.title = "Done"
        }
    }
    
    func addRecipe() {
        // space here?
        // validate text entries
        
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
        
        // create image file
        
        let pickedImage = recipeImage ?? UIImage(named: "default-image") // save default or just do nil? if nil, make image as default on list. or make image not optional?
        
        guard let image = pickedImage,
              let imageData = image.jpegData(compressionQuality: 0.1) else {
            print("error creating image data")
            return
        }
        
        let imageFile = ParseFile(name: "image.jpg", data: imageData)
        
        // create recipe

        var recipe = recipeToEdit ?? Recipe()
        // space here?
        recipe.name = name
        recipe.prepTime = prepTimeNum
        recipe.imageFile = imageFile
        recipe.directions = directions
        recipe.user = User.current
        
        // save recipe to database

        saveRecipe(recipe: recipe)
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
//    private func saveRecipe() {
//        onAddRecipe?() // match what this does w/ shop item
//        dismiss(animated: true)
//    }
    
    private func saveRecipe(recipe: Recipe) {
        recipe.save { [weak self] result in
             DispatchQueue.main.async {
                 switch result {
                 case .success(let recipe): // diff name here n shop item?
                     print("Recipe saved! \(recipe)")
                     self?.onAddRecipe?() // match what this does w/ shop item
                     self?.dismiss(animated: true)
                 case .failure(let error):
                     self?.showFailedSaveAlert(description: error.localizedDescription)
                     print("recipe not saved - error")
                 }
             }
         }
    }
}

// methods to control screen inputs

extension AddRecipeViewController: UITextFieldDelegate {
    // return key dismisses keyboard on text fields
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
    
    private func showFailedSaveAlert(description: String? = nil) { // description on both of these?
        let alertController = UIAlertController(title: "Error saving recipe.", message: "\(description ?? "Unknown error")", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) // upper v lower k?
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}
