//
//  RecipesViewController.swift
//  RecipesApp
//
//  Created by Aaron Garman on 6/17/24.
//

import UIKit

class RecipesViewController: UIViewController, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recipesTableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeCell
        let recipe = recipes[indexPath.row]
        
        cell.nameLabel.text = recipe.name
        cell.prepTimeLabel.text = "Prep Time: \(recipe.prepTime) mins"
        
        return cell
    }
    

    @IBOutlet weak var recipesTableView: UITableView!
    
    private var recipes: [Recipe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipesTableView.dataSource = self
        
        addMockData()
    }
    
    func addMockData() {
        recipes.append(Recipe(name: "Recipe That is More Than 2 Lines Long Test Ellipsis", prepTime: 60))
        recipes.append(Recipe(name: "Recipe", prepTime: 60))
        recipes.append(Recipe(name: "Recipe", prepTime: 60))
        recipes.append(Recipe(name: "Recipe", prepTime: 60))
        recipes.append(Recipe(name: "Recipe", prepTime: 60))
        recipes.append(Recipe(name: "Recipe", prepTime: 60))
        recipes.append(Recipe(name: "Recipe", prepTime: 60))
        recipes.append(Recipe(name: "Recipe", prepTime: 60))
        recipes.append(Recipe(name: "Recipe", prepTime: 60))
        recipes.append(Recipe(name: "Recipe", prepTime: 60))
        recipes.append(Recipe(name: "Recipe", prepTime: 60))
    }
}

// move 2 funcs to extension?

