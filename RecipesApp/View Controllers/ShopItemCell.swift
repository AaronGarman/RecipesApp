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
    
    // take any funcs out? maybe do configure func?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
