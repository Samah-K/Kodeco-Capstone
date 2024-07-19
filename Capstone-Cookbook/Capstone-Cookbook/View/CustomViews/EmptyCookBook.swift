//
//  EmptyCookBook.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 19/07/2024.
//

import SwiftUI

struct EmptyCookBook: View {
  @Binding var tabSelection: Int
  var body: some View {
    VStack(spacing: 30) {
      Image(ImagesConstants.EmptyCookBook)
        .resizable()
        .scaledToFit()
        .shadow(color: Color.black.opacity(0.5), radius: 10, x: -20, y: 20)
      VStack {
        Text(TextsConstants.emptyCookBook)
          .font(.body.smallCaps())
          .multilineTextAlignment(.center)
          .foregroundColor(.text)

        NavigationLink {
          var recipe = Recipe(tastyRecipe: nil, recipeType: RecipeType.myRecipe)
          var recipeBinding: Binding<Recipe> {
            Binding(
              get: { recipe },
              set: { recipe = $0 }
            )
          }
          AddRecipeView(recipe: recipeBinding)
        } label: {
          Text(TextsConstants.emptyCookBookAddNewRecipes)
            .font(.body.smallCaps())
            .multilineTextAlignment(.center)
            .foregroundColor(.accent)
        }

        Text(TextsConstants.emptyCookBookExplore)
          .font(.body.smallCaps())
          .multilineTextAlignment(.center)
          .foregroundColor(.accent)
          .onTapGesture {
            tabSelection = 2
          }
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

#Preview {
  EmptyCookBook(tabSelection: .constant(1))
}
