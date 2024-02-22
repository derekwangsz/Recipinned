//
//  PinnedView.swift
//  Recipinned
//
//  Created by Derek Wang on 2022-03-24.
//

import SwiftUI

struct PinnedView: View {
    // THE IMAGE SOMETIMES DOESN'T LOAD BECAUSE OUR ACCESS HAS EXPIRED. THIS IS DUE TO NOT PAYING FOR THE EDAMAME API...
    
    //MARK: - Refactor this view and break it down further!
    
    @EnvironmentObject var savedRecipes: SavedRecipes
    
    @State private var savedImages = [Image]()
    
    @State private var loadingState: LoadingType = .loading
    
    var body: some View {
        NavigationView {
            
            if loadingState == .loading {
                loadingView
            }
            else {
                sucessView
            }
        }
    }
    
    //MARK: - Refactored Views
    
    var sucessView: AnyView {
        if savedRecipes.savedRecipes.count == 0 {
            return AnyView(noRecipesView)
        }
        else {
            return AnyView(recipesListView)
        }
    }
    
    var recipesListView: some View {
        List {
            ForEach(0..<savedRecipes.savedRecipes.count, id: \.self) { index in
                NavigationLink {
                    DetailView(fromPinnedView: true, recipe: savedRecipes.savedRecipes[index])
                } label: {
                    HStack {
                        Text(savedRecipes.savedRecipes[index].label)
                            .font(.subheadline)
                        
                        if index < savedImages.count {
                            savedImages[index]
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        } else {
                            Spacer()
                                .task {
                                    await fetchImages()
                                }
                        }
                    }
                }
                .listRowBackground(Color("peach"))
                .swipeActions {
                    Button(role: .destructive) {
                        deleteRecipe(index: index)
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
            
        }
        .onAppear {
            print("Initiated List")
        }
        .navigationTitle("Pinned Recipes")
    }
    
    var noRecipesView: some View {
        Text("You don't have any pinned recipes yet... 🥲")
            .font(.system(size: 25, weight: .thin, design: .rounded))
            .navigationTitle("Pinned Recipes")
            .multilineTextAlignment(.center)
    }
    
    var loadingView: some View {
        ProgressView("Retrieving Saved Recipes")
            .padding()
            .task {
                await fetchImages()
            }
            .navigationTitle("Pinned Recipes")
    }
    
    
    //MARK: - Methods
    
    //MARK: - TRY TO USE THE METHODS FROM RECIPESERVICE
    
    func fetchImages() async {
        print("Fetched Images Pinned View")
        savedImages = []
        for currentRecipe in savedRecipes.savedRecipes {
            await savedImages.append(
                Image(systemName: "x.circle")
                    .data(url: URL(string: currentRecipe.regularImageURL)!))
        }
        loadingState = .success
    }
    
    func deleteRecipe(index: Int) {
        let matchIndex = savedRecipes.savedRecipes.firstIndex {
            $0 == savedRecipes.savedRecipes[index]
        }
        print("deleted \(savedRecipes.savedRecipes[matchIndex!].label)")
        
        withAnimation {
            savedRecipes.remove(at: matchIndex!)
            savedImages.remove(at: matchIndex!)
        }
    }
}

struct PinnedView_Previews: PreviewProvider {
    static var previews: some View {
        PinnedView()
    }
}
