//
//  RecipeCell.swift
//  RecipesApp
//
//  Created by Aaron Garman on 6/17/24.
//

import UIKit

class RecipeCell: UITableViewCell {

    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var prepTimeLabel: UILabel!
    
    func configure(with recipe: Recipe) {
        nameLabel.text = recipe.name
        prepTimeLabel.text = "Prep Time: \(recipe.prepTime) mins"
        //recipeImageView.image = recipe.image // Fix for query db
    }
}
