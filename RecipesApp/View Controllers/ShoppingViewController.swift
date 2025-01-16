//
//  ShoppingViewController.swift
//  RecipesApp
//
//  Created by Aaron Garman on 6/17/24.
//

import UIKit

class ShoppingViewController: UIViewController {

    @IBOutlet weak var shoppingTableView: UITableView!
    
    private var shopItems: [ShopItem] = [] {
        didSet {
            //emptyStateLabel.isHidden = !shopItems.isEmpty // add in
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shopItems = ShopItem.mockedShopItems
        
        //shoppingTableView.tableHeaderView = UIView()
        shoppingTableView.dataSource = self
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

// Methods for conformance to Table View Protocol

extension ShoppingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = shoppingTableView.dequeueReusableCell(withIdentifier: "ShopItemCell", for: indexPath) as! ShopItemCell
        let shopItem = shopItems[indexPath.row]
        
        cell.nameLabel.text = shopItem.name
        cell.quantityLabel.text = "Qty: \(shopItem.quantity)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil // Prevent row selection
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                // Update the data model
                shopItems.remove(at: indexPath.row)
                
                // Delete the row from the table view
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                print(shopItems.count)
            }
    }
}
