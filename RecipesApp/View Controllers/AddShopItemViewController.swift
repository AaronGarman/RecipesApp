//
//  AddShopItemViewController.swift
//  RecipesApp
//
//  Created by Aaron Garman on 7/9/24.
//

import UIKit

class AddShopItemViewController: UIViewController {

    @IBOutlet weak var quantityLabel: UILabel!
    
    
    @IBAction func didTapQuantityStepper(_ sender: UIStepper) {
        quantityLabel.text = "\(Int(sender.value))"
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // on add check value stepper > 0 (cast to int) and text input ok
}
