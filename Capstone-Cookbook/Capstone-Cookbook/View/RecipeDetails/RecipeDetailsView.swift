//
//  RecipeDetailsView.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 02/07/2024.
//

import SwiftUI

struct RecipeDetailsView: View {
  @EnvironmentObject var recipeStoreManager: RecipesStore
  @State private var descriptionShowingModal = false
  @State var recipe: Recipe
  @Environment(\.verticalSizeClass)
  var verticalSizeClass
  @Environment(\.horizontalSizeClass)
  var horizontalSizeClass
  var body: some View {
    let isPortraitMode = verticalSizeClass == .regular && horizontalSizeClass == .compact
    ZStack {
      VStack {
        if isPortraitMode {
          RecipeDetailsViewPortrait(
            recipe: recipe,
            descriptionShowingModal: $descriptionShowingModal)
        } else {
          RecipeDetailsViewLandscape(
            recipe: recipe,
            descriptionShowingModal: $descriptionShowingModal)
        }
      }
      .padding(.bottom, 30)
      if $descriptionShowingModal.wrappedValue {
        if let description = recipe.tastyRecipe.description {
          CustomPopup(
            isPopPresented: $descriptionShowingModal,
            popText: description)
        }
      }
    }
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        if recipe.recipeType == .tastyRecipe {
          AddRecipeButton(
            isAddedToMyRecipes: $recipe.isRecipeAddedToMyCookbook,
            recipeID: recipe.id)
        } else {
          NavigationLink {
            AddRecipeView(recipe: $recipe, addOrEdit: .editRecipe)
          } label: {
            Text("Edit")
          }
        }
      }
    }
  }
}

struct RecipeDetailsViewPortrait: View {
  @State var recipe: Recipe
  @Binding var descriptionShowingModal: Bool
  var body: some View {
    GeometryReader { proxy in
      ScrollView {
        VStack {
          // image
          VStack {
            VStack {
              if let url = recipe.tastyRecipe.imageDataURL {
                RecipeAsyncImage(thumbnailURL: url)
              } else {
                RecipeImage(thumbnailURL: recipe.tastyRecipe.getRecipeImageURL())
              }
            }
            .frame(width: 280, height: 280)
            .clipShape(RoundedRectangle(cornerRadius: ViewConstants.roundCorner))
            .shadow(radius: 3.0)
          }
          .padding(.top, 20)
          .frame(height: proxy.size.height * 0.4)
          // Recipe Name + Recipe Description
          VStack {
            VStack(spacing: 15) {
              Text(recipe.tastyRecipe.name)
                .font(.title)
                .padding(.top, 10)
                .multilineTextAlignment(.center)
              RecipeTime(recipe: recipe)
              Text(recipe.tastyRecipe.description ?? " - ")
                .font(.subheadline)
                .lineLimit(4)
                .allowsTightening(true)
                .onTapGesture {
                  descriptionShowingModal = true
                }
            }
            .padding(.horizontal, 20)
            .frame(height: proxy.size.height * 0.4)
            VStack {
              VStack {
                NavigationLink {
                  InstructionListView(
                    instructions: recipe.tastyRecipe.instructions,
                    videoURL: recipe.tastyRecipe.videoURL)
                } label: {
                  RecipeDetailsButton(
                    imageName: ImagesConstants.Instructions,
                    text: TextsConstants.InstructionsButton,
                    background: Color.accentColor)
                }
              }
              VStack {
                NavigationLink {
                  IngredientListView(ingredientSection: recipe.tastyRecipe.ingredientSections)
                } label: {
                  RecipeDetailsButton(
                    imageName: ImagesConstants.Ingredient,
                    text: TextsConstants.IngredientButton,
                    background: Color.tint
                  )
                }
              }
            }
            .frame(height: proxy.size.height * 0.2)
            .padding(.top, 8)
          }
        }
      }
    }
  }
}

struct RecipeDetailsViewLandscape: View {
  @State var recipe: Recipe
  @Binding var descriptionShowingModal: Bool
  var body: some View {
    GeometryReader { proxy in
      ScrollView {
        HStack {
          // image
          VStack {
            HStack {
              if let url = recipe.tastyRecipe.imageDataURL {
                RecipeAsyncImage(thumbnailURL: url)
              } else {
                RecipeImage(thumbnailURL: recipe.tastyRecipe.getRecipeImageURL())
              }
            }
            .frame(width: 280, height: 280)
            .clipShape(RoundedRectangle(cornerRadius: ViewConstants.roundCorner))
            .shadow(radius: 3.0)
          }
          .frame(width: proxy.size.width * 0.4, alignment: .center)
          .frame(maxHeight: .infinity)
          // Recipe Name + Recipe Description
          VStack {
            VStack(spacing: 15) {
              Text(recipe.tastyRecipe.name)
                .font(.title)
                .padding(.top, 10)
                .multilineTextAlignment(.center)
              RecipeTime(recipe: recipe)
              Text(recipe.tastyRecipe.description ?? " - ")
                .font(.subheadline)
                .lineLimit(4)
                .allowsTightening(true)
                .onTapGesture {
                  descriptionShowingModal = true
                }
            }
            .padding(.horizontal, 20)
            .frame(
              width: proxy.size.width * 0.6,
              height: proxy.size.height * 0.6
            )
            HStack {
              VStack {
                NavigationLink {
                  InstructionListView(
                    instructions: recipe.tastyRecipe.instructions,
                    videoURL: recipe.tastyRecipe.videoURL)
                } label: {
                  RecipeDetailsButton(
                    imageName: ImagesConstants.Instructions,
                    text: TextsConstants.InstructionsButton,
                    background: Color.accentColor)
                }
              }
              VStack {
                NavigationLink {
                  IngredientListView(ingredientSection: recipe.tastyRecipe.ingredientSections)
                } label: {
                  RecipeDetailsButton(
                    imageName: ImagesConstants.Ingredient,
                    text: TextsConstants.IngredientButton,
                    background: Color.tint
                  )
                }
              }
            }
            .frame(height: proxy.size.height * 0.3)
            .padding(.top, 8)
          }
        }
      }
    }
  }
}

struct RecipeTime: View {
  @State var recipe: Recipe
  var body: some View {
    HStack(alignment: .firstTextBaseline) {
      Spacer()
      Spacer()
      HStack(alignment: .center) {
        Image("\(ImagesConstants.PrepareTime)")
          .resizable()
          .frame(width: 25, height: 25)
        if let prepareTime = recipe.tastyRecipe.prepTimeMinutes, prepareTime != 0 {
          Text(HandleMeasurement().calculateTotalTime(prepTime: prepareTime, cookTime: 0))
        } else {
          Text("-")
        }
      }
      Spacer()
      HStack {
        Image(systemName: "frying.pan")
          .frame(width: 25, height: 25)
        if let cookTime = recipe.tastyRecipe.cookTimeMinutes, cookTime != 0 {
          Text(HandleMeasurement().calculateTotalTime(prepTime: 0, cookTime: cookTime))
        } else {
          Text("-")
        }
      }
      Spacer()
      Spacer()
      Spacer()
    }
  }
}

struct RecipeDetailsButton: View {
  let imageName: String
  let text: String
  let background: Color
  var body: some View {
    HStack {
      Image(imageName)
        .resizable()
        .frame(width: 30, height: 30)
      Text(text)
        .font(.title2)
        .foregroundStyle(.white)
    }
    .padding()
    .background(background)
    .clipShape(RoundedRectangle(cornerRadius: ViewConstants.roundCorner))
    .overlay {
      RoundedRectangle(cornerRadius: ViewConstants.roundCorner)
        .stroke(.white, lineWidth: 2.0)
    }
  }
}

#Preview {
  struct Preview: View {
    private static let tastyRecipe = TastyJSONSample().getRecipeFromJSONFile()?.recipes[0]
    @State var recipe = Recipe(tastyRecipe: tastyRecipe, recipeType: .myRecipe)
    var body: some View {
      NavigationStack {
        RecipeDetailsView(recipe: recipe)
          .environmentObject(RecipesStore())
      }
    }
  }
  return Preview()
}
