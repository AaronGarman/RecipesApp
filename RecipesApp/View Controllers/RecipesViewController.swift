//
//  RecipesViewController.swift
//  RecipesApp
//
//  Created by Aaron Garman on 6/17/24.
//

import UIKit
import ParseSwift

class RecipesViewController: UIViewController {

    @IBOutlet weak var recipesTableView: UITableView!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    private var recipes: [Recipe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // recipes = Recipe.mockedRecipes // out for testing db
        
        recipesTableView.dataSource = self
        recipesTableView.delegate = self
        
        menuInit()
        
        queryRecipes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIndexPath = recipesTableView.indexPathForSelectedRow {
            recipesTableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddRecipeSegue" {
            guard let addRecipeNavController = segue.destination as? UINavigationController,
                  let addRecipeViewController = addRecipeNavController.topViewController as? AddRecipeViewController else { return }
            
            if let recipeToEdit = sender as? Recipe {
                addRecipeViewController.recipeToEdit = recipeToEdit
            }
            
            addRecipeViewController.onAddRecipe = { [weak self] in
                self?.queryRecipes()
            }
        }
        else if segue.identifier == "RecipeDetailSegue" { // maybe do if let? gpt?
            guard let selectedIndexPath = recipesTableView.indexPathForSelectedRow else { return }
            let selectedRecipe = recipes[selectedIndexPath.row]
            guard let recipeDetailViewController = segue.destination as? RecipeDetailViewController else { return }
            recipeDetailViewController.recipe = selectedRecipe
        }
    }

    private func menuInit() {
        let menuItems = UIMenu(options: .displayInline, children: [
            UIAction(title: "Sign out", image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), handler: { _ in self.showConfirmLogoutAlert() })
        ])
        
        settingsButton.menu = menuItems
    }
}

// Database operations

extension RecipesViewController {
//    private func queryRecipes() {
//        print("recipes query")
//    }
    
    private func queryRecipes() {
        guard let currentUser = User.current else {
            print("No current user found.")
            return
        }
        
        do {
            let query = try Recipe.query()
                .where("user" == currentUser)
                .order([.ascending("createdAt")])
            
            query.find { [weak self] result in
                switch result {
                case .success(let recipes):
                    self?.recipes = recipes
                    self?.recipesTableView.reloadData()
                case .failure(let error):
                    self?.showFailedQueryAlert(description: error.localizedDescription)
                    print(error.localizedDescription)
                }
            }
        } catch {
            showFailedQueryAlert(description: error.localizedDescription)
            print(error.localizedDescription)
        }
    }
    
    private func deleteRecipe(at indexPath: IndexPath) {
        let recipe = recipes[indexPath.row]
        
        recipe.delete { [weak self] result in
            switch result {
            case .success:
                self?.queryRecipes()
            case .failure(let error):
                self?.showFailedDeleteAlert(description: "Failed to delete item: \(error.localizedDescription)")
            }
        }
    }
}

// Table View data + delegate methods

extension RecipesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = recipesTableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as? RecipeCell else {
            print("Unable to dequeue ShopItemCell")
            return UITableViewCell()
        }
        
        cell.configure(with: recipes[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let selectedRecipe = recipes[indexPath.row]
        let detailAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (action, view, completionHandler) in
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
//                recipes.remove(at: indexPath.row)
//                tableView.deleteRows(at: [indexPath], with: .fade)
            deleteRecipe(at: indexPath)
        }
    }
}

// Alerts + error messages

extension RecipesViewController {
    private func showFailedQueryAlert(description: String? = nil) {
        let alertController = UIAlertController(title: "Error loading recipes.", message: "\(description ?? "Unknown error")", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    private func showFailedDeleteAlert(description: String? = nil) {
        let alertController = UIAlertController(title: "Error deleting recipe.", message: "\(description ?? "Unknown error")", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    private func showConfirmLogoutAlert() {
        let alertController = UIAlertController(title: "Sign out of your account?", message: nil, preferredStyle: .alert)
        let logOutAction = UIAlertAction(title: "Sign out", style: .destructive) { _ in
            NotificationCenter.default.post(name: Notification.Name("signOut"), object: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(logOutAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}
