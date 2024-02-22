
//
//  SearchView.swift
//  Recipinned
//
//  Created by Derek Wang on 2022-03-24.
//

import SwiftUI

struct SearchView: View {
    //MARK: - HANDLE THE ERRORS BETTER -> LET THE USER KNOW!
    //MARK: - RIGHT NOW THE APP DOESNT DIFFERENTIATE BETWEEN AN INVALID RECIPE NAME AND NO WIFI CONNECTION, FIND A WAY TO DO SO!
    
    @EnvironmentObject var savedRecipes: SavedRecipes
    
    @State private var searchWord = ""
    
    @State private var searchedRecipes = [Recipe]()
    
    @State private var isEditing = false
    @State private var loadingState: LoadingType = .success
    @State private var loadingError: RecipeWebError = .fetchError
    
    var body: some View {
        NavigationView {
            VStack {
                searchField
                Spacer()
                if loadingState == .failed {
                    if !isEditing {
                        errorView
                    }
                }
                
                else if loadingState == .loading {
                    loadingView
                }
                
                else {
                    //MARK: - Refactor the scrollview so that it reuses RecipeLink view
                    ScrollView(showsIndicators: true) {
                        recipesVStack
                    }
                }
                
                Spacer()
            }
            .background(Color("base"))
            .navigationTitle("Search Recipes")
        }
        
    }
    
    //MARK: - Refactored Views
    
    var recipesVStack: some View {
        VStack(spacing: 30) {
            ForEach(searchedRecipes) { recipe in
                RecipeLink(recipe: recipe)
            }
            
            if !searchedRecipes.isEmpty {
                loadMoreButton
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    var searchField: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .font(.headline)
            
            TextField("Search", text: $searchWord, prompt: Text(" Search for recipes..."))
                .textFieldStyle(.roundedBorder)
                .onTapGesture {
                    withAnimation {
                        isEditing = true
                    }
                }
                .onSubmit {
                    submitSearch()
                }
            
            if isEditing {
                clearButton
            }
        }
        .padding()
        .background(Color("green").opacity(0.3))
    }
    
    var clearButton: some View {
        Button {
            searchWord = ""
        } label: {
            Image(systemName: "x.circle")
                .tint(.secondary)
        }
    }
    
    var refreshButton: some View {
        Button {
            print("refresh button pressed")
            loadingState = .loading
        } label: {
            Image(systemName: "arrow.counterclockwise")
                .foregroundColor(.mint)
                .padding(.horizontal, 20)
                .padding(.vertical, 5)
                .background(.thickMaterial)
                .cornerRadius(10)
        }
    }
    
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
    
    var loadingView: some View {
        ProgressView("Retrieving \(searchWord.capitalized) Recipes")
            .padding()
            .task {
                await getSearchResults()
            }
    }
    
    var errorView: AnyView {
        switch loadingError {
        case .fetchError:
            return AnyView(
                Group {
                Text("No internet, please check your connection.")
                refreshButton
            }
            )
        case .decodeError:
            return AnyView(Text("DECODE ERROR"))
        case .badURLError:
            return AnyView(Text("BAD URL ERROR"))
        case .badNameError:
            return AnyView(Text("Sorry, we don't have recipes of \(searchWord)..."))
        }
    }
    
    //MARK: - Methods
    
    func submitSearch() {
        withAnimation {
            isEditing = false
        }
        
        print("submitted")
        
        if searchWord != "" {
            searchedRecipes = []
            loadingState = .loading
            Task {
                await getSearchResults()
            }
        }
    }
    
    func getSearchResults() async {
        // fetch recipes
        let goodSearchWord = searchWord.replacingOccurrences(of: " ", with: "")
        print(goodSearchWord)
        do {
            let results = try await RecipeService.fetchRecipes(with: goodSearchWord, from: .search)
            searchedRecipes = results
            loadingState = .success
        } catch {
            loadingError = error as! RecipeWebError
            loadingState = .failed
            print(error)
        }
    }
    
    func fetchNextPage() async {
        do {
            let results = try await RecipeService.fetchNextPage(of: .search)
            searchedRecipes.append(contentsOf: results)
        } catch {
            loadingError = error as! RecipeWebError
            print(loadingError)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
