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
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        addMockData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIndexPath = recipesTableView.indexPathForSelectedRow {
            recipesTableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedIndexPath = recipesTableView.indexPathForSelectedRow else {return}
        let selectedRecipe = recipes[selectedIndexPath.row]
        guard let recipeDetailViewController = segue.destination as? RecipeDetailViewController else {return}
        recipeDetailViewController.recipe = selectedRecipe
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

