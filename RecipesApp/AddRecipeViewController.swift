//
//  AddRecipeViewController.swift
//  RecipesApp
//
//  Created by Aaron Garman on 7/9/24.
//

import UIKit

class AddRecipeViewController: UIViewController {

    @IBOutlet weak var directionsTextView: UITextView!
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add border to the UITextView - keep v make as rules in storyboard? sends warning in console?
        directionsTextView.layer.borderColor = UIColor.black.cgColor
        directionsTextView.layer.borderWidth = 1.0
        directionsTextView.layer.cornerRadius = 5.0 // Optional, for rounded corners
         
        // Do any additional setup after loading the view.
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
