//
//  RecipeItemView.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 06/07/2024.
//

import SwiftUI

struct RecipeItemView: View {
  let widthPercentage = 0.4
  let heightPercentage = 0.4
  @EnvironmentObject var recipeStoreManager: RecipesStore
  @Binding var recipe: Recipe

  var body: some View {
    ZStack(alignment: .bottomTrailing) {
      RoundedRectangle(cornerRadius: ViewConstants.roundCorner)
        .fill(Color.background)
        .shadow(radius: 10)
        .frame(
          maxWidth: .infinity,
          minHeight: ViewConstants.minListHeight,
          maxHeight: ViewConstants.maxListHeight
        )
      GeometryReader { proxy in
        HStack(alignment: .center, spacing: 10) {
          VStack {
            VStack {
              if let url = recipe.tastyRecipe.imageDataURL {
                RecipeAsyncImage(thumbnailURL: url)
                  .frame(width: 130, height: 130)
                  .clipShape(RoundedRectangle(cornerRadius: ViewConstants.roundCorner))
              } else {
                RecipeImage(thumbnailURL: recipe.tastyRecipe.getRecipeImageURL())
                  .frame(width: 130, height: 130)
                  .clipShape(RoundedRectangle(cornerRadius: ViewConstants.roundCorner))
              }
            }
            .padding(.leading, 8)
          }
          .frame(width: proxy.size.width * 0.4)
          VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading) {
              Text(recipe.getRecipeName())
                .font(.title3)
                .foregroundStyle(Color.text)
                .multilineTextAlignment(.leading)
                .shadow(color: .tint.opacity(0.3), radius: 1)
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.trailing, 8)
            }
            .frame(height: proxy.size.height * 0.5)
            if !recipe.getTotalCookTime().isEmpty {
              HStack(spacing: 5) {
                Image(systemName: "timer")
                Text(recipe.getTotalCookTime())
              }
              .foregroundStyle(Color.text)
              .frame(height: proxy.size.height * 0.5, alignment: .center)
              .font(.caption)
            }
          }
          .frame(maxWidth: proxy.size.width * (1 - 0.4))
          .padding(.leading, 10)
        }
      }
      ZStack {
        Circle()
          .fill(.white)
          .shadow(radius: 5)
          .frame(maxWidth: 25, maxHeight: 25)
        AddRecipeButton(
          isAddedToMyRecipes: $recipe.isRecipeAddedToMyCookbook,
          recipeID: recipe.id
        )
      }
      .padding()
    }
    .frame(
      maxWidth: .infinity,
      minHeight: ViewConstants.minListHeight,
      maxHeight: ViewConstants.minListHeight)
    .padding()
  }
}

#Preview {
  RecipeItemView(
    recipe: .constant(TastyRecipeModel().getExample()))
  .environmentObject(RecipesStore())
}
