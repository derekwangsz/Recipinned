//
//  Recipe.swift
//  Recipinned
//
//  Created by Derek Wang on 2022-03-23.
//

import Foundation

class SavedRecipes: ObservableObject {
    
    // encapsulation
    // this forces the client to use the 'add' method because the 'savedRecipes' list is private(set).
    @Published private(set) var savedRecipes: [Recipe]
    
    let savePath = FileManager.documentsDirectory.appendingPathComponent("Recipes")
    
    init() {
        do {
            let data = try Data(contentsOf: savePath)
            savedRecipes = try JSONDecoder().decode([Recipe].self, from: data)
        } catch {
            savedRecipes = []
        }
    }
    
    
    // encapsulate the functionality of adding a prospect to the 'recipes' list.
    // this forces the client to use the 'add' method because the 'recipes' list is private(set).
    private func save() {
        do {
            let encoded = try JSONEncoder().encode(savedRecipes)
            try encoded.write(to: savePath, options: [.atomic, .completeFileProtection])
            print("Successfully saved data.")
        } catch {
            print("Unable to save data.")
        }
    }
    
    // force the client to use this 'add' function to add a prospect to the prospects list.
    func add(_ recipe: Recipe) {
        savedRecipes.append(recipe)
        save()
    }
    
    func remove(at index: Int) {
        savedRecipes.remove(at: index)
        save()
    }
    
    func pop() {
        savedRecipes.removeLast()
        save()
    }
    
    func get(at index: Int) -> Recipe {
        return savedRecipes[index]
    }
}

