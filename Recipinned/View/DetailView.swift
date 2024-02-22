//
//  DetailView.swift
//  Recipinned
//
//  Created by Derek Wang on 2022-03-27.
//

import SwiftUI

enum NutritionType: String, CaseIterable {
    case fat = "Fat"
    case chole = "Cholesterol"
    case sugar = "Sugar"
    case potas = "Potassium"
    
    static var allCases: [NutritionType] {
        [.fat, .chole, .sugar, .potas]
    }
}

struct DetailView: View {
    
    // design the UI of DetailView - make it look extra good!
    // Add a pin button in the view to make it easy for the user to pin the recipe
    // display all the information in a neat way
    
    //MARK: - REFACTOR THIS VIEW MORE, BREAK IT DOWN
    
    @EnvironmentObject var savedRecipes: SavedRecipes
    
    @State private var isPinned = false
    @State private var showingAlert = false
    @State private var recipeImage: Image?
    
    var fromPinnedView: Bool
    
    var recipe: Recipe
    var body: some View {
        
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack {
                    recipeImageView
                    
                    cuisineTypeView
                    
                    ingredientsView
                    
                    nutritionView
                }
            }
            .task {
                recipeImage = await Image("x.circle").data(url: URL(string: recipe.regularImageURL)!)
            }
            .background(Color("peach"))
            .listStyle(.inset)
            .toolbar {
                pinButton
            }
            .alert(isPinned ? "Recipe is pinned!" : "Unpinned Recipe", isPresented: $showingAlert) {
                Button("OK") {}
            }
            .frame(maxWidth: .infinity)
            
        }
        .navigationTitle(recipe.label)
        .navigationBarTitleDisplayMode(.inline)
        
    }
    
    //MARK: - Refactored views
    
    var cuisineTypeView: some View {
        VStack {
            Text(recipe.cuisineType.joined(separator: ", ").capitalized)
                .font(.callout)
                .bold()
            
            Divider()
            
            Text("🔥 \(Int(recipe.calories)) cal ")
                .font(.system(size: 20, weight: .light, design: .monospaced))
        }
        .padding()
        .frame(maxWidth: 300)
        .background(.white.opacity(0.1))
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    var ingredientsView: some View {
        VStack(spacing: 15) {
            Text("📜 INGREDIENTS")
                .font(.system(size: 25, weight: .bold, design: .serif))
            
            Text("- " + recipe.ingredientLines.joined(separator: "\n- "))
                .font(.system(size: 20, weight: .light, design: .serif))
                .padding(.horizontal)
        }
        .padding(.top, 15)
        .padding(.bottom, 40)
    }
    
    var nutritionView: some View {
        VStack(spacing: 15) {
            Text("📊 NUTRITION")
                .font(.system(size: 25, weight: .bold, design: .serif))
            
            Divider()
            
            nutrientsView
        }
        .padding()
        .padding(.bottom, 20)
        .background(.thinMaterial)
        .cornerRadius(10)
        .font(.body)
        .padding()
        .padding(.bottom, 40)
        
    }
    
    var nutrientsView: some View {
        let fatAmount = recipe.totalNutrients.FAT.quantity
        let fatUnit = recipe.totalNutrients.FAT.unit
        let fatAmountStr = "\(String(format:"%.1f", fatAmount)) \(fatUnit)"
        
        let choleAmount = recipe.totalNutrients.CHOLE.quantity
        let choleUnit = recipe.totalNutrients.CHOLE.unit
        let choleAmountStr = "\(String(format:"%.1f", choleAmount)) \(choleUnit)"
        
        let sugarAmount = recipe.totalNutrients.SUGAR.quantity
        let sugarUnit = recipe.totalNutrients.SUGAR.unit
        let sugarAmountStr = "\(String(format:"%.1f", sugarAmount)) \(sugarUnit)"
        
        let kAmount = recipe.totalNutrients.K.quantity
        let kUnit = recipe.totalNutrients.K.unit
        let kAmountStr = "\(String(format:"%.1f", kAmount)) \(kUnit)"
        
        let nutritionDict: [NutritionType:String] = [
            .fat : fatAmountStr,
            .chole: choleAmountStr,
            .sugar: sugarAmountStr,
            .potas: kAmountStr
        ]
        
        return VStack(spacing: 20) {
            ForEach(NutritionType.allCases, id: \.self) { nutritionType in
                HStack {
                    Text(nutritionType.rawValue)
                        .font(.headline)
                    
                    Spacer()
                    
                    Text(nutritionDict[nutritionType] ?? "Unknown")
                }
            }
        }
    }
    
    var recipeImageView: AnyView {
        if recipeImage != nil {
            return AnyView(
                recipeImage!
                .resizable()
                .scaledToFit()
                .cornerRadius(15)
            )
        } else {
            return AnyView(ProgressView().frame(height: 350))
        }
        
    }
    
    var pinButton: AnyView {
        if !fromPinnedView {
            return AnyView (
                Button {
                    isPinned.toggle()
                    if isPinned {
                        savedRecipes.add(recipe)
                    } else {
                        savedRecipes.pop()
                    }
                    showingAlert = true
                    print("Pin pressed")
                    
                } label: {
                    isPinned ? Image(systemName: "pin.fill") : Image(systemName: "pin")
                }
            )
        } else {
            return AnyView(EmptyView())
        }
    }
}

