//
//  ShoppingViewController.swift
//  RecipesApp
//
//  Created by Aaron Garman on 6/17/24.
//

import UIKit
import ParseSwift

class ShoppingViewController: UIViewController {

    @IBOutlet weak var shoppingTableView: UITableView!
    
    private var shopItems: [ShopItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // shopItems = ShopItem.mockedShopItems // out for testing db
        
        shoppingTableView.dataSource = self
        shoppingTableView.delegate = self
        
        queryShopItems()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let addShopItemNavController = segue.destination as? UINavigationController,
              let addShopItemViewController = addShopItemNavController.topViewController as? AddShopItemViewController else { return }
            
        if let shopItemToEdit = sender as? ShopItem {
            addShopItemViewController.shopItemToEdit = shopItemToEdit
        }
        
        addShopItemViewController.onAddShopItem = { [weak self] in
            self?.queryShopItems()
        }
    }
}

// Database operations

extension ShoppingViewController {
    private func queryShopItems() {
        guard let currentUser = User.current else {
            print("No current user found.")
            return
        }
        
        do {
            let query = try ShopItem.query()
                .where("user" == currentUser)
                .order([.ascending("createdAt")])
            
            query.find { [weak self] result in
                switch result {
                case .success(let shopItems):
                    self?.shopItems = shopItems
                    self?.shoppingTableView.reloadData()
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
    
    private func deleteShopItem(at indexPath: IndexPath) {
        let item = shopItems[indexPath.row]
        
        item.delete { [weak self] result in
            switch result {
            case .success:
                self?.queryShopItems()
            case .failure(let error):
                self?.showFailedDeleteAlert(description: "Failed to delete item: \(error.localizedDescription)")
            }
        }
    }
}

// Table View data + delegate methods

extension ShoppingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = shoppingTableView.dequeueReusableCell(withIdentifier: "ShopItemCell", for: indexPath) as? ShopItemCell else {
            print("Unable to dequeue ShopItemCell")
            return UITableViewCell()
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
            deleteShopItem(at: indexPath)
        }
    }
}

// Alerts + error messages

extension ShoppingViewController {
    private func showFailedQueryAlert(description: String? = nil) {
        let alertController = UIAlertController(title: "Error loading shopping list items.", message: "\(description ?? "Unknown error")", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        
        present(alertController, animated: true)
    }
    
    private func showFailedDeleteAlert(description: String? = nil) {
        let alertController = UIAlertController(title: "Error deleting shopping list item.", message: "\(description ?? "Unknown error")", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        
        present(alertController, animated: true)
    }
}
