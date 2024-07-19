//
//  EmptyCookBook.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 19/07/2024.
//

import SwiftUI

struct EmptyCookBook: View {
  @Binding var tabSelection: Int
  @State private var isAnimating = false
  var body: some View {
    VStack(spacing: 30) {
      Image(ImagesConstants.EmptyCookBook)
        .resizable()
        .scaledToFit()
        .shadow(color: Color.black.opacity(0.5), radius: 10, x: -20, y: 20)
        .opacity(isAnimating ? 1 : 0.6)
        .scaleEffect(isAnimating ? 1.0 : 0.8)
      VStack(spacing: 10) {
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
    .onAppear {
      withAnimation(.smooth(duration: 1.2)) {
        isAnimating = true
      }
    }
    .onDisappear {
      isAnimating = false
    }
  }
}

#Preview {
  EmptyCookBook(tabSelection: .constant(1))
}
