//
//  WebService.swift
//  Recipinned
//
//  Created by Derek Wang on 2022-06-23.
//

import Foundation
import Network
import SwiftUI

//MARK: - Useful Enums
enum RecipeWebError: Error {
    case fetchError
    case decodeError
    case badURLError
    case badNameError
}

enum RecipeViewType {
    case search
    case browse
}

//MARK: - Static Variables

struct RecipeService {
    
    private static var browseNextURLStr = ""
    private static var searchNextURLStr = ""
    
    private static var browseNextURL: URL {
        URL(string: browseNextURLStr) ?? URL(string:"www.google.ca")!
    }
    
    private static var searchNextURL: URL {
        URL(string: searchNextURLStr) ?? URL(string:"www.google.ca")!
    }
    
    //MARK: - Fetch Next Page
    static func fetchNextPage(of viewType: RecipeViewType) async throws -> [Recipe] {
        var url = URL(string: "www.google.ca")
        
        switch viewType {
        case .browse:
            url = browseNextURL
        case .search:
            url = searchNextURL
        }
        
        guard let goodURL = url else {
            throw RecipeWebError.badURLError
        }
        
        guard let (data, _) = try? await URLSession.shared.data(from: goodURL) else {
            throw RecipeWebError.fetchError
        }
        
        guard let results = try? JSONDecoder().decode(RecipeResult.self, from: data) else {
            throw RecipeWebError.decodeError
        }
        
        var recipes = [Recipe]()
        for hit in results.hits {
            recipes.append(hit.recipe)
        }
        
        return recipes
        
    }
    
    //MARK: - Fetch with a Search Word
    static func fetchRecipes(with searchWord: String, from viewType: RecipeViewType) async throws -> [Recipe] {
        let urlString = "https://api.edamam.com/api/recipes/v2?type=public&q=\(searchWord)&app_id=a3558de9&app_key=568f8f8faca91d76bb19162834e1cd9f"
        
        print("Fetching \(searchWord) recipes")
        
        guard let url = URL(string: urlString) else {
            print("Bad url: \(urlString)")
            throw RecipeWebError.badURLError
        }
        
        let result = await fetch(with: url, from: viewType)
        
        switch result {
        case let .success(recipes):
            print("Done fetching \(searchWord) recipes")
            return recipes
        case let .failure(error):
            throw error
        }
    }
    
    //MARK: - Fetch method
    
    private static func fetch(with url: URL, from viewType: RecipeViewType) async -> Result<[Recipe],Error> {
        
        // this checks if the user is connected wifi or not
        let monitor = NWPathMonitor()
        monitor.start(queue: .global())
        
        var result: Result<[Recipe], Error>!
        
        guard let (data, _) = try? await URLSession.shared.data(from: url) else {
            print("FAILED TO FETCH DATA")
            print(monitor.currentPath.status)
            
            if monitor.currentPath.status == .satisfied {
                result = .failure(RecipeWebError.badNameError)
            } else {
                result = .failure(RecipeWebError.fetchError)
            }
            return result
        }
        
        guard let results = try? JSONDecoder().decode(RecipeResult.self, from: data) else {
            result = .failure(RecipeWebError.decodeError)
            return result
        }
        
        if let nextLinkURLStr = results._links["next"]?["href"] {
            switch viewType {
            case .browse:
                browseNextURLStr = nextLinkURLStr
            case .search:
                searchNextURLStr = nextLinkURLStr
            }
        }
        
        print("browse next url: \(browseNextURLStr)")
        print("search next url: \(searchNextURLStr)")
        
        var recipes: [Recipe] = []
        
        for hit in results.hits {
            recipes.append(hit.recipe)
        }
        
        result = .success(recipes.shuffled())
        return result
    }
}
