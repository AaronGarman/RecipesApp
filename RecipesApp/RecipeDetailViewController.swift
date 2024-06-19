//
//  RecipeDetailViewController.swift
//  RecipesApp
//
//  Created by Aaron Garman on 6/18/24.
//

import UIKit

class RecipeDetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var prepTimeLabel: UILabel!
    @IBOutlet weak var directionsTextView: UITextView!
    
    var recipe: Recipe!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never // no need if take out nav title?
        
        nameLabel.text = recipe.name
        prepTimeLabel.text = "Prep Time: \(recipe.prepTime) mins"

    }
}
