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
        recipesTableView.delegate = self // need?
        
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
                addRecipeViewController.recipeToEdit = sender as? Recipe // test if this needed
                addRecipeViewController.onAddRecipe = { [weak self] recipe in
                    
                    // if update, else add new
                    
                    if ((self?.recipes.firstIndex(where: {$0.name == recipe.name})) != nil) {
                        let index = Int((self?.recipes.firstIndex(where: {$0.name == recipe.name}) ?? self?.recipes.count)!)
                        // force unwrap above bad? do as if let?
                        // also will need diff identifier to edit, maybe when db? // do if let or guard let?
                        self?.recipes.remove(at: index)
                        self?.recipes.insert(recipe, at: index)
                    }
                    else {
                        self?.recipes.append(recipe)
                    }
                    
                    self?.recipesTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                    
                    //self?.recipes.append(recipe)
                    //self?.recipesTableView.reloadData()
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

extension RecipesViewController: UITableViewDataSource, UITableViewDelegate {
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