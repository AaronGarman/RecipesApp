//
//  AddShopItemViewController.swift
//  RecipesApp
//
//  Created by Aaron Garman on 7/9/24.
//

import UIKit

class AddShopItemViewController: UIViewController {

    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantityStepper: UIStepper!
    
    var shopItemToEdit: ShopItem?
    var onAddShopItem: (() -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        
        initUI()
    }
    
    @IBAction func onViewTapped(_ sender: Any) {
        // Dismiss keyboard
        view.endEditing(true)
    }
    
    @IBAction func didTapQuantityStepper(_ sender: UIStepper) {
        quantityLabel.text = "\(Int(sender.value))"
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func didTapAddButton(_ sender: Any) {
        addShopItem()
    }
    
    private func initUI() {
        quantityStepper.minimumValue = 1
        quantityStepper.value = 1
        
        setupEditMode()
        
        quantityLabel.text = ("\(Int(quantityStepper.value))")
    }
    
    private func setupEditMode() {
        if let shopItem = shopItemToEdit {
            nameTextField.text = shopItem.name
            quantityStepper.value = Double(shopItem.quantity)
            
            self.title = "Edit Shop Item"
            addButton.title = "Done"
        }
    }
    
    private func addShopItem() {
        guard let name = nameTextField.text, !name.isEmpty else {
            showEmptyNameFieldAlert()
            return
        }

        let quantityNum = Int(quantityStepper.value)
        
        var shopItem = shopItemToEdit ?? ShopItem()
        
        shopItem.name = name
        shopItem.quantity = quantityNum
        shopItem.user = User.current
        
        saveShopItem(shopItem: shopItem)
    }
}

// Database operations

extension AddShopItemViewController {
    private func saveShopItem(shopItem: ShopItem) {
        shopItem.save { [weak self] result in
             DispatchQueue.main.async {
                 switch result {
                 case .success(let shopItem):
                     print("ShopItem saved! \(shopItem)")
                     self?.onAddShopItem?()
                     self?.dismiss(animated: true)
                 case .failure(let error):
                     self?.showFailedSaveAlert(description: error.localizedDescription)
                     print("shopItem not saved - error")
                 }
             }
         }
    }
}

// methods to control screen inputs

extension AddShopItemViewController: UITextFieldDelegate {
    // return key dismisses keyboard on text fields
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// Error messages

extension AddShopItemViewController {
    private func showEmptyNameFieldAlert() {
        let alertController = UIAlertController(
            title: "Error",
            message: "Name field must be filled out.",
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)

        present(alertController, animated: true)
    }
    
    private func showFailedSaveAlert(description: String? = nil) {
        let alertController = UIAlertController(title: "Error saving shopping list item.", message: "\(description ?? "Unknown error")", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}
