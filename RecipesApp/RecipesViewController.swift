//
//  RecipesViewController.swift
//  RecipesApp
//
//  Created by Aaron Garman on 6/17/24.
//

import UIKit

class RecipesViewController: UIViewController {

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

// move funcs to extension? or back up top? do same in shopping view controller

// conformance to Table View Protocol

extension RecipesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recipesTableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeCell
        let recipe = recipes[indexPath.row]
        
        cell.nameLabel.text = recipe.name
        cell.prepTimeLabel.text = "Prep Time: \(recipe.prepTime) mins"
        
        // will take this out, just for testing
        let randNum = Int.random(in: 0...2)
        if randNum == 0 {
            cell.recipeImageView.image = UIImage(named: "chicken marsala image")
            cell.nameLabel.text = "Chicken Marsala"
        }
        else if randNum == 1 {
            cell.recipeImageView.image = UIImage(named: "pasta image")
            cell.nameLabel.text = "Aaron's World Famous Pasta"
        }
        else {
            cell.recipeImageView.image = UIImage(named: "pizza image")
            cell.nameLabel.text = "Pizza"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                // Update the data model
                recipes.remove(at: indexPath.row)
                
                // Delete the row from the table view
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                print(recipes.count)
            }
    }
}
