//
//  RecipeCell.swift
//  RecipesApp
//
//  Created by Aaron Garman on 6/17/24.
//

import UIKit
import Alamofire
import AlamofireImage

class RecipeCell: UITableViewCell {

    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var prepTimeLabel: UILabel!
    
    private var imageDataRequest: DataRequest?
    
    func configure(with recipe: Recipe) {
        nameLabel.text = recipe.name
        prepTimeLabel.text = "Prep Time: \(recipe.prepTime) mins"
        //recipeImageView.image = recipe.image // Fix for query db
        
        if let imageFile = recipe.imageFile,
           let imageUrl = imageFile.url {
            
            // Use AlamofireImage helper to fetch remote image from URL
            imageDataRequest = AF.request(imageUrl).responseImage { [weak self] response in
                switch response.result {
                case .success(let image):
                    // Set image view image with fetched image
                    self?.recipeImageView.image = image
                case .failure(let error):
                    print("Error fetching image: \(error.localizedDescription)")
                    break
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        recipeImageView.image = nil
        imageDataRequest?.cancel()

    }
}
