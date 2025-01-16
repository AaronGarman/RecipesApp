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
            ShopItem(name: "Milk", quantity: 1),
            ShopItem(name: "Cheese", quantity: 1),
            ShopItem(name: "Bread", quantity: 2),
            ShopItem(name: "Dish Soap", quantity: 1),
            ShopItem(name: "Eggs - dozen pack", quantity: 1),
            ShopItem(name: "Apples", quantity: 4),
            ShopItem(name: "Rice", quantity: 1),
            ShopItem(name: "Ground Beef - 1 lb", quantity: 1),
            ShopItem(name: "Carrots", quantity: 2),
            ShopItem(name: "Water - 24 Pack", quantity: 1),
            ShopItem(name: "Coffee", quantity: 1),
            ShopItem(name: "Greek Yogurt", quantity: 3),
        ]
    }
}

