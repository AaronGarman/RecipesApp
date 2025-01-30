//
//  ShopItem.swift
//  RecipesApp
//
//  Created by Aaron Garman on 6/17/24.
//

import Foundation

struct ShopItem {
    let id: UUID = UUID()
    var name: String
    var quantity: Int
}

// mock data for testing

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
