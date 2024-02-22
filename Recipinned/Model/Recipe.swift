//
//  Recipes.swift
//  Recipinned
//
//  Created by Derek Wang on 2022-03-25.
//

import Foundation
import SwiftUI

struct RecipeResult: Codable {
    var _links: [String: [String: String]]
    var hits: [Hit]
}

struct Hit: Codable {
    var recipe: Recipe
}

// this Recipe struct is going to include a name(string), ingredientLines([string]), and an image(RecipeImages - which digs down deep and need to retreive an image from provided url from base RecipeImage struct), and also contain some nutrient info

struct Recipe: Codable {
    var label: String
    var images: RecipeImages
    var ingredientLines: [String]
    var calories: Double
    var cuisineType: [String]
    var totalNutrients: TotalNutrients
    
    var thumbnailImageURL: String {
        images.THUMBNAIL.url
    }
    
    var smallImageURL: String {
        images.SMALL.url
    }
    
    var regularImageURL: String {
        images.REGULAR.url
    }
    
    
    // NESTED STRUCTS TO ENFORCE CODABLE
    struct RecipeImages: Codable {
        var THUMBNAIL: RecipeImage
        var SMALL: RecipeImage
        var REGULAR: RecipeImage
        
        
        struct RecipeImage: Codable {
            var url: String
            var width: Int
            var height: Int
        }
    }
    
    struct TotalNutrients: Codable {
        var FAT : Nutrient
        var SUGAR: Nutrient
        var CHOLE: Nutrient
        var K : Nutrient
        
        struct Nutrient: Codable {
            var label: String
            var quantity: Double
            var unit: String
        }
    }
}

//MARK: - Recipe Extensions

extension Recipe: Identifiable {
    var id: UUID {
        UUID()
    }
}

extension Recipe: Equatable {
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.regularImageURL == rhs.regularImageURL && lhs.label == rhs.label
    }
}

extension Recipe: Comparable {
    static func < (lhs: Recipe, rhs: Recipe) -> Bool {
        lhs.label < rhs.label
    }
}

