//
//  Recipe.swift
//  RecipesApp
//
//  Created by Aaron Garman on 6/17/24.
//

import Foundation
import UIKit

struct Recipe {
    let id: UUID = UUID()
    var name: String = ""
    var prepTime: Int = 0
    var image: UIImage?
    var directions: String = ""
}

// mock data for testing

extension Recipe {
    static var mockedRecipes: [Recipe] {
        return [
            Recipe(name: "Grilled Chicken", prepTime: 25, image: UIImage(named: "grilled-chicken"), directions: "Directions"),
            Recipe(name: "Pizza", prepTime: 30, image: UIImage(named: "pizza"), directions: "Directions"),
            Recipe(name: "Fettucine Alfredo", prepTime: 45, image: UIImage(named: "fettuccine-alfredo"), directions: "Directions"),
            Recipe(name: "Tacos", prepTime: 20, image: UIImage(named: "tacos"), directions: "Directions"),
            Recipe(name: "Mac & Cheese", prepTime: 35, image: UIImage(named: "mac-n-cheese"), directions: "Directions"),
            Recipe(name: "Chicken Marsala", prepTime: 60, image: UIImage(named: "chicken-marsala"), directions: "Directions"),
            Recipe(name: "Greek Salad", prepTime: 15, image: UIImage(named: "greek-salad"), directions: "Directions"),
            Recipe(name: "Tiramisu", prepTime: 35, image: UIImage(named: "tiramisu"), directions: "Directions")
        ]
    }
}
