//
//  ContentView.swift
//  Recipinned
//
//  Created by Derek Wang on 2022-03-23.
//

import SwiftUI

// FIX LAUNCH SCREEN?
// rest of app works pretty well

struct ContentView: View {
    @StateObject var savedRecipes = SavedRecipes()
    
    init() {
    }
    
    var body: some View {
        TabView {
            BrowseView()
                .tabItem {
                    Label("Browse", systemImage: "house")
                }
            
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
             
            PinnedView()
                .tabItem {
                    Label("Pinned", systemImage: "pin")
                }
        }
        .environmentObject(savedRecipes)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
