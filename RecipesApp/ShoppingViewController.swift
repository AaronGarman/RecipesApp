//
//  ShoppingViewController.swift
//  RecipesApp
//
//  Created by Aaron Garman on 6/17/24.
//

import UIKit

class ShoppingViewController: UIViewController, UITableViewDataSource {
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
    
    @IBOutlet weak var shoppingTableView: UITableView!
    
    private var shopItems: [ShopItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shoppingTableView.dataSource = self
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        addMockDate()
        
    }
    
    func addMockDate() {
        shopItems.append(ShopItem(name: "bread", quantity: 1))
        shopItems.append(ShopItem(name: "bread", quantity: 1))
        shopItems.append(ShopItem(name: "bread", quantity: 1))
        shopItems.append(ShopItem(name: "bread", quantity: 1))
        shopItems.append(ShopItem(name: "bread", quantity: 1))
        shopItems.append(ShopItem(name: "bread", quantity: 1))
        shopItems.append(ShopItem(name: "bread", quantity: 1))
        shopItems.append(ShopItem(name: "bread", quantity: 1))
        shopItems.append(ShopItem(name: "bread", quantity: 1))
        shopItems.append(ShopItem(name: "bread", quantity: 1))
        shopItems.append(ShopItem(name: "bread", quantity: 1))
        shopItems.append(ShopItem(name: "bread", quantity: 1))
        shopItems.append(ShopItem(name: "bread", quantity: 1))
        shopItems.append(ShopItem(name: "bread", quantity: 1))
        shopItems.append(ShopItem(name: "bread", quantity: 1))
        shopItems.append(ShopItem(name: "bread", quantity: 1))
    }
}
