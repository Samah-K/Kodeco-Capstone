//
//  RecipeItemView.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 06/07/2024.
//

import SwiftUI

struct RecipeItemView: View {
  @EnvironmentObject var recipeStoreManager: RecipeStoresManager
  @Binding var recipe: Recipe

  var body: some View {
    ZStack(alignment: .topTrailing) {
      ZStack(alignment: .bottom) {
        HStack {
          if let photoURL = recipe.tastyRecipe.imageDataURL {
            AsyncImage(url: photoURL) { imagePhase in
              switch imagePhase {
              case .empty:
                RoundedRectangle(cornerRadius: 25.0)
                  .fill(.gray)
              case .success(let image):
                image.resizable()
              case .failure(let error):
                Text(error.localizedDescription)
                RoundedRectangle(cornerRadius: 25.0)
                  .fill(.gray)
              @unknown default:
                RoundedRectangle(cornerRadius: 25.0)
                  .fill(.gray)
              }
            }
          } else {
            ZStack {
              RoundedRectangle(cornerRadius: 25.0)
                .fill(.gray)
              ProgressView()
                .tint(.accent)
            }
          }
        }
        HStack(alignment: .firstTextBaseline) {
          Spacer()
          Text(recipe.tastyRecipe.name)
            .font(.title)
            .fontDesign(.rounded)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .shadow(radius: 4)
            .shadow(color: .black, radius: 1)
            .shadow(color: .accent, radius: 1)
            .lineLimit(2)
            .padding(.horizontal, 9)
          Spacer()
          Spacer()
          Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 15)
      }
      HStack {
        ZStack {
          Circle()
            .fill(.white)
            .shadow(radius: 10)
            .frame(maxWidth: 25, maxHeight: 25)
          AddRecipeButton(
            isAddedToMyRecipes: $recipe.isRecipeAddedToMyCookbook,
            recipeID: recipe.id
          )
        }
      }
      .padding(10)
    }
    .clipShape(RoundedRectangle(cornerRadius: 25))
    .aspectRatio(1, contentMode: .fit)
    .overlay {
      RoundedRectangle(cornerRadius: 25)
        .strokeBorder(.white, lineWidth: 4.0)
    }
    .shadow(radius: 1)
  }
}

#Preview {
  RecipeItemView(
    recipe: .constant(TastyRecipeModel().getExample()))
  .environmentObject(RecipeStoresManager())
}
