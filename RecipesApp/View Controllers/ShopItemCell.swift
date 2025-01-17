//
//  ShopItemCell.swift
//  RecipesApp
//
//  Created by Aaron Garman on 6/17/24.
//

import UIKit

class ShopItemCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    func configure(with shopItem: ShopItem) {
        nameLabel.text = shopItem.name
        quantityLabel.text = "Qty: \(shopItem.quantity)"
    }
}
