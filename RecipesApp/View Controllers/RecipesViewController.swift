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
            //emptyStateLabel.isHidden = !recipes.isEmpty // add in?
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipes = Recipe.mockedRecipes
        
        //recipesTableView.tableHeaderView = UIView() // UI styling - try?
        recipesTableView.dataSource = self
        recipesTableView.delegate = self
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIndexPath = recipesTableView.indexPathForSelectedRow {
            recipesTableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
        
        //recipesTableView.reloadData() // no need?
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddRecipeSegue" {
            if let addRecipeNavController = segue.destination as? UINavigationController,
               let addRecipeViewController = addRecipeNavController.topViewController as? AddRecipeViewController {
                
                // Passing recipe to edit if provided
                if let recipeToEdit = sender as? Recipe {
                    addRecipeViewController.recipeToEdit = recipeToEdit
                }
                
                addRecipeViewController.onAddRecipe = { [weak self] recipe in
                    guard let self = self else { return }
                    
                    // Check if the recipe exists and determine action
                    if let index = self.recipes.firstIndex(where: { $0.id == recipe.id }) {
                        // Update existing recipe
                        self.recipes[index] = recipe
                    }
                    else {
                        // Add new recipe
                        self.recipes.append(recipe)
                    }
                    
                    // Refresh the table view
                    self.recipesTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                }
            }
        }
        else if segue.identifier == "RecipeDetailSegue" {
            guard let selectedIndexPath = recipesTableView.indexPathForSelectedRow else { return }
            let selectedRecipe = recipes[selectedIndexPath.row]
            guard let recipeDetailViewController = segue.destination as? RecipeDetailViewController else { return }
            recipeDetailViewController.recipe = selectedRecipe
        }
    }
}

// Methods for conformance to Table View Protocol

extension RecipesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = recipesTableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as? RecipeCell else {
            fatalError("Unable to dequeue Recipe Cell")
        }
        
        cell.configure(with: recipes[indexPath.row])

        return cell
    }

// FIG ABOVE FIRST - only prepare now?
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        guard let addRecipeViewController = segue.destination as? AddRecipeViewController else {return}
//        addRecipeViewController.recipeToEdit = sender as? Recipe
        let detailAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (action, view, completionHandler) in
            let selectedRecipe = self?.recipes[indexPath.row] // maybe this above outside of closure?
            self?.performSegue(withIdentifier: "AddRecipeSegue", sender: selectedRecipe)
            completionHandler(true)
        }
        detailAction.backgroundColor = .orange

        let configuration = UISwipeActionsConfiguration(actions: [detailAction])
        configuration.performsFirstActionWithFullSwipe = true

        return configuration
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
