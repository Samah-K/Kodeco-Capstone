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
        .fill(.white)
        .shadow(radius: 10)
        .frame(
          maxWidth: .infinity,
          minHeight: ViewConstants.minListHeight,
          maxHeight: ViewConstants.maxListHeight)
      GeometryReader { proxy in
        HStack(alignment: .center, spacing: 10) {
          VStack {
            VStack {
              // Check the type
              if let url = recipe.tastyRecipe.imageDataURL {
                RecipeAsyncImage(thumbnailURL: url)
                  .frame(width: 130, height: 130)
                  .clipShape(RoundedRectangle(cornerRadius: ViewConstants.roundCorner))
              } else {
                ZStack {
                  RecipeImage(thumbnailURL: recipe.tastyRecipe.getRecipeImageURL())
                    .frame(width: 130, height: 130)
                    .clipShape(RoundedRectangle(cornerRadius: ViewConstants.roundCorner))
                }
              }
            }
            .padding(.leading, 12)
          }
          .frame(width: proxy.size.width * 0.4)
          VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading) {
              Text(recipe.getRecipeName())
                .font(.body)
                .foregroundStyle(.text)
                .multilineTextAlignment(.leading)
                .shadow(color: .tint.opacity(0.3), radius: 1)
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(height: proxy.size.height * 0.5)
            if !recipe.getTotalCookTime().isEmpty {
                HStack(spacing: 5) {
              Image(systemName: "timer")
              Text(recipe.getTotalCookTime())
            }
              .frame(height: proxy.size.height * 0.5, alignment: .center)
//              .background(.green)
              .font(.caption)
              .foregroundStyle(.accentSecondary)
          }
//            Spacer()
//            Spacer()
          }
          .frame(maxWidth: proxy.size.width * (1 - 0.4))
          .padding(.leading, 10)
//          .background(.red)
//          .frame(width: proxy.size.width * 0.6)
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
