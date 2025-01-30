//
//  ShoppingViewController.swift
//  RecipesApp
//
//  Created by Aaron Garman on 6/17/24.
//

import UIKit

class ShoppingViewController: UIViewController {

    @IBOutlet weak var shoppingTableView: UITableView!
    
    private var shopItems: [ShopItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shopItems = ShopItem.mockedShopItems
        
        shoppingTableView.dataSource = self
        shoppingTableView.delegate = self
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIndexPath = shoppingTableView.indexPathForSelectedRow {
            shoppingTableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddShopItemSegue" { // where is all this + UI any? name segues here n below? no need the if now?
            if let addShopItemNavController = segue.destination as? UINavigationController,
               let addShopItemViewController = addShopItemNavController.topViewController as? AddShopItemViewController {
                
                // Passing recipe to edit if provided
                if let shopItemToEdit = sender as? ShopItem {
                    addShopItemViewController.shopItemToEdit = shopItemToEdit
                }
                
                addShopItemViewController.onAddShopItem = { [weak self] shopItem in
                    
                    // Check if the recipe exists and determine action
                    if let index = self?.shopItems.firstIndex(where: { $0.id == shopItem.id }) {
                        // Update existing recipe
                        self?.shopItems[index] = shopItem
                    }
                    else {
                        // Add new recipe
                        self?.shopItems.append(shopItem)
                    }
                    
                    // Refresh the table view
                    self?.shoppingTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                }
            }
        }
//        else if segue.identifier == "ShopItemDetailSegue" { // no do this?
//            guard let selectedIndexPath = shoppingTableView.indexPathForSelectedRow else { return }
//            let selectedShopItem = shopItems[selectedIndexPath.row]
//            guard let shopItemDetailViewController = segue.destination as? ShopItemDetailViewController else { return }
//            shopItemDetailViewController.shopItem = selectedShopItem
//        }
    }
    
    // prepare + delegate above, delegate method below too
}

// Methods for conformance to Table View Protocol

extension ShoppingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = shoppingTableView.dequeueReusableCell(withIdentifier: "ShopItemCell", for: indexPath) as? ShopItemCell else {
            fatalError("Unable to dequeue ShopItemCell")
        }
        
        cell.configure(with: shopItems[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let selectedShopItem = shopItems[indexPath.row]
        let detailAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (action, view, completionHandler) in
            self?.performSegue(withIdentifier: "AddShopItemSegue", sender: selectedShopItem)
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
                shopItems.remove(at: indexPath.row)
                
                // Delete the row from the table view
                tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

// maybe refactor shopItem to just item?
