//
//  ShopItem.swift
//  RecipesApp
//
//  Created by Aaron Garman on 6/17/24.
//

import Foundation

struct ShopItem {
    let name: String
    let quantity: Int
    
    // add/delete more data items as need
    
    // need init or set?
}

// make all mock data unique

extension ShopItem {
    static var mockedShopItems: [ShopItem] {
        return [
            ShopItem(name: "first", quantity: 1),
            ShopItem(name: "bread", quantity: 1),
            ShopItem(name: "bread", quantity: 1),
            ShopItem(name: "bread", quantity: 1),
            ShopItem(name: "bread", quantity: 1),
            ShopItem(name: "bread", quantity: 1),
            ShopItem(name: "bread", quantity: 1),
            ShopItem(name: "bread", quantity: 1),
            ShopItem(name: "middle", quantity: 1),
            ShopItem(name: "bread", quantity: 1),
            ShopItem(name: "bread", quantity: 1),
            ShopItem(name: "bread", quantity: 1),
            ShopItem(name: "bread", quantity: 1),
            ShopItem(name: "bread", quantity: 1),
            ShopItem(name: "bread", quantity: 1),
            ShopItem(name: "last", quantity: 1)
        ]
    }
}

