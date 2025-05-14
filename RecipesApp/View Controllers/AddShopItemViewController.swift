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
    
    @IBAction func didTapQuantityStepper(_ sender: UIStepper) {
        quantityLabel.text = "\(Int(sender.value))"
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func didTapAddButton(_ sender: Any) {
        guard let name = nameTextField.text,
              let quantity = quantityLabel.text,
                !name.isEmpty,
                !quantity.isEmpty else {
            showEmptyFieldsAlert()
            return }
        
        guard let quantityNum = Int(quantity) else { return }
        
        var shopItem: ShopItem // maybe just call item?
        
        if let editedShopItem = shopItemToEdit {
            shopItem = editedShopItem
            
            shopItem.name = name
            shopItem.quantity = quantityNum
        }
        else {
            shopItem = ShopItem(name: name, quantity: quantityNum)
        }
        
        onAddShopItem?(shopItem)
        dismiss(animated: true)
    }
    
    var shopItemToEdit: ShopItem? // vars at top?
    var onAddShopItem: ((ShopItem) -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quantityStepper.value = 1
        quantityStepper.minimumValue = 1
        
        if let shopItem = shopItemToEdit {
            nameTextField.text = shopItem.name
            quantityLabel.text = ("\(shopItem.quantity)")
            
            // stepper value somehow?
            quantityStepper.value = Double(shopItem.quantity)
            
            self.title = "Edit Shop Item"
            addButton.title = "Done" // update? other one too
        }

        // Do any additional setup after loading the view.
    }
    
    private func showEmptyFieldsAlert() {
        let alertController = UIAlertController(
            title: "Error",
            message: "Name field must be filled out",
            preferredStyle: .alert) // caps need? just say all fields?

        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)

        present(alertController, animated: true)
    }
    
    // on add check value stepper > 0 (cast to int) and text input ok
    // fig alerts at end
}
