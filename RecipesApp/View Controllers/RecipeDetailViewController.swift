//
//  RecipeDetailViewController.swift
//  RecipesApp
//
//  Created by Aaron Garman on 6/18/24.
//

import UIKit

class RecipeDetailViewController: UIViewController {

    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var prepTimeLabel: UILabel!
    @IBOutlet weak var directionsTextView: UITextView!
    
    var recipe: Recipe!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never // no need if take out nav title?
        navigationItem.title = recipe.name
        
        // make image bigger n text smaller?
        // more room for directions?
        // font size and bold vs no?
        
// try border?
        //recipeImageView.layer.borderColor = UIColor.black.cgColor
        //recipeImageView.layer.borderWidth = 1.0
        recipeImageView.layer.cornerRadius = 5.0 // decide value?

/* try shadow effect?
        recipeImageView.layer.shadowColor = UIColor.black.cgColor
        recipeImageView.layer.shadowOpacity = 0.5
        recipeImageView.layer.shadowOffset = CGSize(width: 4, height: 4)
        recipeImageView.layer.shadowRadius = 4
        //recipeImageView.layer.masksToBounds = false

        // Optional: Add a border to the image view
        recipeImageView.layer.borderWidth = 1.0
        recipeImageView.layer.borderColor = UIColor.lightGray.cgColor
 */
        //recipeImageView.image = recipe.image // Fix for query db
        prepTimeLabel.text = "Prep Time: \(recipe.prepTime) mins"
        directionsTextView.text = recipe.directions
        
        directionsTextView.layer.borderColor = UIColor.black.cgColor
        directionsTextView.layer.borderWidth = 1.0
        directionsTextView.layer.cornerRadius = 5.0 // decide value?
    }
}

// more functions here n other files
