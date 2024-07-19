//
//  AddRecipeButton.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 09/07/2024.
//

import SwiftUI

struct AddRecipeButton: View {
  @EnvironmentObject var recipeStoreManager: RecipesStore
  @Binding var isAddedToMyRecipes: Bool
  var recipeID: String
  @State private var isRemoveRecipeAlertPresented = false

  var body: some View {
    Button(action: {
      // Add or remove
      if isAddedToMyRecipes {
        print("Remove")
        // Remove
        isRemoveRecipeAlertPresented = true
      } else {
        print("Add")
        // Add
        if recipeStoreManager.addRecipeToMyCookBook(recipeID: recipeID) {
          isAddedToMyRecipes = true
        }
      }
    }, label: {
      Image(systemName: isAddedToMyRecipes ? "heart.fill" : "heart")
        .tint(Color.tint)
    })
    .alert(TextsConstants.removeRecipeConfirmationAlertTitle, isPresented: $isRemoveRecipeAlertPresented) {
      Button("No", role: .cancel) {
        isRemoveRecipeAlertPresented = false
      }
      Button("Yes", role: .destructive) {
        isAddedToMyRecipes = false
        recipeStoreManager.removeRecipeFromMyCookBook(recipeID: recipeID)
      }
    }
  }
}

#Preview {
  AddRecipeButton(isAddedToMyRecipes: .constant(true), recipeID: "\(951)")
    .environmentObject(RecipesStore())
}
