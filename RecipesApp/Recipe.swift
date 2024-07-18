//
//  Recipe.swift
//  RecipesApp
//
//  Created by Aaron Garman on 6/17/24.
//

import Foundation
import UIKit

struct Recipe {
    var name: String
    var prepTime: Int
    var image: UIImage?
    var directions: String
    
    // add/delete more data items as need
    
    // need init or set?
}

// make all mock data unique

extension Recipe {
    static var mockedRecipes: [Recipe] {
        return [
            Recipe(name: "Chicken Marsala", prepTime: 60, image: UIImage(named: "chicken marsala image"), directions: "Directions"),
            Recipe(name: "Aaron's World Famous Pasta", prepTime: 60, image: UIImage(named: "pasta image"), directions: "Directions"),
            Recipe(name: "Pizza", prepTime: 60, image: UIImage(named: "pizza image"), directions: "Directions"),
            Recipe(name: "Chicken Marsala", prepTime: 60, image: UIImage(named: "chicken marsala image"), directions: "Directions"),
            Recipe(name: "Aaron's World Famous Pasta", prepTime: 60, image: UIImage(named: "pasta image"), directions: "Directions"),
            Recipe(name: "Pizza", prepTime: 60, image: UIImage(named: "pizza image"), directions: "Directions"),
            Recipe(name: "Chicken Marsala", prepTime: 60, image: UIImage(named: "chicken marsala image"), directions: "Directions"),
            Recipe(name: "Aaron's World Famous Pasta", prepTime: 60, image: UIImage(named: "pasta image"), directions: "Directions"),
            Recipe(name: "Pizza", prepTime: 60, image: UIImage(named: "pizza image"), directions: "Directions"),
            Recipe(name: "Chicken Marsala", prepTime: 60, image: UIImage(named: "chicken marsala image"), directions: "Directions")
        ]
    }
}
