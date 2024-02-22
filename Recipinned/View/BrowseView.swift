//
//  BrowseView.swift
//  Recipinned
//
//  Created by Derek Wang on 2022-03-24.
//

import SwiftUI

struct BrowseView: View {
    
    //MARK: - PINNING A VIEW WORKS BUT ALSO IMMEDIATE GOES BACK TO BROWSE VIEW, FIX IT! P.S. this problem does not exist if we go from SearchView
    
    // this view refreshes and reloads the images every time the user pins a recipe, change the way we load the image (maybe store the images in a separate local list). This way the user only needs to wait the first time and the view does't refresh every time.
    
    //MARK: - TRY TO IMPLEMENT PAGINATION
    //MARK: - HANDLE THE ERRORS BETTER -> LET THE USER KNOW!
    
    @EnvironmentObject var savedRecipes: SavedRecipes
    
    @State private var fetchedRecipes = [Recipe]()
    @State private var cuisineType = "american"
    @State private var loadingState: LoadingType = .loading
    
    let cuisineTypes = ["american", "italian", "chinese", "mexican", "japanese", "french", "british", "indian", "turkish", "canadian", "spanish", "portuguese", "cantonese", "malaysian"]
    
    var body: some View {
        if loadingState == .failed {
            VStack {
                Text("No internet, please check your connection.")
                refreshButton
            }
            
        } else if loadingState == .loading {
            ProgressView {
                Text("Retrieving \(cuisineType.capitalized) Recipes")
                    .font(.headline)
            }
            .padding()
            .task {
                await fetchRecipes()
            }
            .onAppear {
                print("Progress view appeared")
            }
            
        } else {
            NavigationView {
                ScrollView {
                    // display the fetched recipes in a scrollview
                    VStack(spacing: 30) {
                        ForEach(fetchedRecipes) { recipe in
                            RecipeLink(recipe: recipe)
                        }
                        
                        loadMoreButton
                    }
                    .frame(maxWidth: .infinity)
                }
                .navigationTitle("Browse Recipes")
                .background(Color("base"))
                .toolbar {
                    refreshButton
                }
            }
        }
        
    }
    
    //MARK: - Refactored Views
    var loadMoreButton: some View {
        Button {
            // load the next set of recipes -> don't need to go back to loading view
            Task {
                await fetchNextPage()
            }
        } label: {
            Image(systemName: "arrow.down").font(.callout)
            Text("Load More").font(.headline)
        }
        .padding(.bottom, 30)
    }
    
    var refreshButton: some View {
        Button {
            print("refresh button pressed")
            loadingState = .loading
        } label: {
            Image(systemName: "arrow.counterclockwise")
                .foregroundColor(.black)
                .font(.headline)
                .padding(.horizontal, 40)
                .padding(.vertical, 5)
                .background(Color("base"))
                .cornerRadius(10)
                .shadow(color: Color("peach"), radius: 10)
        }
    }
    
    
    //MARK: - Methods
    
    func fetchRecipes() async {
        // fetch recipes
        fetchedRecipes = []
        cuisineType = cuisineTypes.randomElement()!
        print(cuisineType)
        
        do {
            let results = try await RecipeService.fetchRecipes(with: cuisineType, from: .browse)
            fetchedRecipes = results
            loadingState = .success
        } catch {
            print(error)
            loadingState = .failed
        }
    }
    
    func fetchNextPage() async {
        do {
            let results = try await RecipeService.fetchNextPage(of: .browse)
            fetchedRecipes.append(contentsOf: results)
        } catch {
            print(error)
        }
    }
}

struct BrowseView_Previews: PreviewProvider {
    static var previews: some View {
        BrowseView()
    }
}
