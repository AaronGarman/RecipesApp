//
//  RecipesViewController.swift
//  RecipesApp
//
//  Created by Aaron Garman on 6/17/24.
//

import UIKit

class RecipesViewController: UIViewController {

    @IBOutlet weak var recipesTableView: UITableView!
    
    private var recipes: [Recipe] = [] {
        didSet {
            //emptyStateLabel.isHidden = !recipes.isEmpty // add in
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipes = Recipe.mockedRecipes
        
        //recipesTableView.tableHeaderView = UIView()
        recipesTableView.dataSource = self
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIndexPath = recipesTableView.indexPathForSelectedRow {
            recipesTableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
        
        recipesTableView.reloadData() // still need after db load?
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddRecipeSegue" {
            if let addRecipeNavController = segue.destination as? UINavigationController,
               let addRecipeViewController = addRecipeNavController.topViewController as? AddRecipeViewController {
                addRecipeViewController.onAddRecipe = { [weak self] recipe in
                    self?.recipes.append(recipe)
                    self?.recipesTableView.reloadData()
                }
            }
        } 
        else if segue.identifier == "RecipeDetailSegue" { // keep if else style same line or put above?
            guard let selectedIndexPath = recipesTableView.indexPathForSelectedRow else {return}
            let selectedRecipe = recipes[selectedIndexPath.row]
            guard let recipeDetailViewController = segue.destination as? RecipeDetailViewController else {return}
            recipeDetailViewController.recipe = selectedRecipe
        }
    }
}

// Methods for conformance to Table View Protocol

extension RecipesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recipesTableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeCell
        let recipe = recipes[indexPath.row]
        
        cell.nameLabel.text = recipe.name
        cell.prepTimeLabel.text = "Prep Time: \(recipe.prepTime) mins"
        cell.recipeImageView.image = recipe.image
        
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
