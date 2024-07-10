//
//  AddRecipeButton.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 09/07/2024.
//

import SwiftUI

struct AddRecipeButton: View {
  @ObservedObject var recipeStoreManager: RecipeStoresManager
  @Binding var isAddedToMyRecipes: Bool
  var recipeID: Int

  var body: some View {
    Button(action: {
      // Add or remove
      if isAddedToMyRecipes {
        print("Remove")
        // Remove
        isAddedToMyRecipes = false
        recipeStoreManager.removeRecipeFromMyCookBook(recipeID: recipeID)
      } else {
        print("Add")
        // Add
        if recipeStoreManager.addRecipeToMyCookBook(recipeID: recipeID) {
          isAddedToMyRecipes = true
        }
      }
    }, label: {
      Image(systemName: isAddedToMyRecipes ? "heart.fill" : "heart")
        .tint(.accent)
    })
  }
}

#Preview {
  AddRecipeButton(recipeStoreManager: RecipeStoresManager(), isAddedToMyRecipes: .constant(true), recipeID: 951)
}
