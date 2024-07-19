//
//  AddRecipeViewController.swift
//  RecipesApp
//
//  Created by Aaron Garman on 7/9/24.
//

import UIKit
import PhotosUI

class AddRecipeViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var prepTimeTextField: UITextField!
    @IBOutlet weak var attachPhotoButton: UIButton!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var directionsTextView: UITextView!
    
    var onAddRecipe: ((Recipe) -> Void)? = nil
    var recipeImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeImageView.layer.cornerRadius = 5.0 // decide value?
        
        // Add border to the UITextView - keep v make as rules in storyboard? sends warning in console?
        directionsTextView.layer.borderColor = UIColor.lightGray.cgColor
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
    
    @IBAction func didTapAttachImageButton(_ sender: Any) {
        if PHPhotoLibrary.authorizationStatus(for: .readWrite) != .authorized {
            // Request photo library access
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
                switch status {
                case .authorized:
                    // The user authorized access to their photo library
                    // show picker (on main thread)
                    DispatchQueue.main.async {
                        self?.showImagePicker()
                    }
                default:
                    // show settings alert (on main thread)
                    DispatchQueue.main.async {
                        // Helper method to show settings alert
                        self?.showGoToSettingsAlert()
                    }
                }
            }
        } else {
            // Show photo picker
            showImagePicker()
        }
    }
    
    @IBAction func didTapOpenCameraButton(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("❌📷 Camera not available")
            return
        }

        // Instantiate the image picker
        let imagePicker = UIImagePickerController()

        // Shows the camera (vs the photo library)
        imagePicker.sourceType = .camera

        // Allows user to edit image within image picker flow (i.e. crop, etc.)
        // If you don't want to allow editing, you can leave out this line as the default value of `allowsEditing` is false
        imagePicker.allowsEditing = true

        // The image picker (camera in this case) will return captured photos via it's delegate method to it's assigned delegate.
        // Delegate assignee must conform and implement both `UIImagePickerControllerDelegate` and `UINavigationControllerDelegate`
        imagePicker.delegate = self

        // Present the image picker (camera)
        present(imagePicker, animated: true)
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
        
        var newImage: UIImage? // do this diff?
        // change to pic once get - helper func for pic get?
        if let image = recipeImage {
            newImage = image
        }
        else {
            newImage = UIImage(named: "pizza image") // make default image for no picture found - put in proj. also take out stock ones?
        }

        let recipe = Recipe(name: name, prepTime: prepTimeNum, image: newImage, directions: directions)
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

// photo picker methods + conformance to photo picker delegate

extension AddRecipeViewController: PHPickerViewControllerDelegate {
    
    private func showImagePicker() {
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
            
            print("🌉 We have an image!")
            
            // need to do dispatch? check lab example
            DispatchQueue.main.async { [weak self] in
                self?.recipeImage = image   // need "?" after image?
                self?.attachPhotoButton.tintColor = .green
                self?.recipeImageView.image = image
/*               // Set the picked image and location on the task
                self?.task.set(image, with: location)
                // Update the UI since we've updated the task
                self?.updateUI()
*/
            }
        }
    }
    
    func showGoToSettingsAlert() {
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
    
    private func showAlert(for error: Error? = nil) {
        let alertController = UIAlertController(
            title: "Error",
            message: "\(error?.localizedDescription ?? "Please try again...")",
            preferredStyle: .alert)

        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)

        present(alertController, animated: true)
    }
}

// camera photo picker methods + conformance to camera picker delegates

extension AddRecipeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Dismiss the image picker
        picker.dismiss(animated: true)

        // Get the edited image from the info dictionary (if `allowsEditing = true` for image picker config).
        // Alternatively, to get the original image, use the `.originalImage` InfoKey instead.
        guard let image = info[.editedImage] as? UIImage else {
            print("❌📷 Unable to get image")
            return
        }
        // do i need dispatch queue here on in version w/ pick?
        recipeImage = image
        recipeImageView.image = image
    }
}


// put all photos stuff as extension? maybe show photo after pick?
// feedback for after user uploads photo?
