//
//  RecipeLink.swift
//  Recipinned
//
//  Created by Derek Wang on 2022-06-23.
//

import SwiftUI

struct RecipeLink: View {
    
    @EnvironmentObject var savedRecipes: SavedRecipes
    
    let recipe: Recipe
    
    var body: some View {
        NavigationLink {
            DetailView(fromPinnedView: false, recipe: recipe)
        } label: {
            AsyncImage(url: URL(string: recipe.regularImageURL)) { image in
                image
                    .cornerRadius(15)
                    .scaledToFit()
                    .overlay(overlayView, alignment: .bottomTrailing)
            } placeholder: {
                ProgressView()
                    .frame(height: 200)
            }
            .padding(.horizontal, 30)
        }
        .shadow(color: Color("peach"), radius: 10)
        .contextMenu {
            Button {
                savedRecipes.add(recipe)
            } label: {
                Label("Pin Recipe", systemImage: "plus")
                    .tint(.blue)
            }
        }
    }
    
    //MARK: - Refactored views
    
    var overlayView: some View {
        Text(recipe.label)
            .font(.callout)
            .foregroundColor(.white)
            .padding()
            .background(.black.opacity(0.3))
            .background(.thinMaterial)
            .cornerRadius(10)
    }
}
