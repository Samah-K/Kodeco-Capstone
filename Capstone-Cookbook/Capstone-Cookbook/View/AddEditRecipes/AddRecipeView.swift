//
//  AddRecipe.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 08/07/2024.
//

import SwiftUI
import PhotosUI

// 💡 A REFERENCE for the Future : Don't update recipes information `immediately` while the user still editing/adding, only update it when user clicks `save`, since the user can change their mind, and decide that they don't want to update the recipe

// TODO: Fix this to add instead of addRecipe
enum AddOrEditEnum: String {
  case addRecipe = "Add New Recipe"
  case editRecipe = "Edit Recipe"
}

struct AddRecipeView: View {
  @EnvironmentObject var recipeStore: RecipesStore
  @Binding var recipe: Recipe
  @State private var recipeName = ""
  @State private var recipeDescription = ""
  @State private var prepTime = 20
  @State private var cookTime = 0
  @State private var numServing = 0
  @State private var thumbnail = ""
  @State private var video = ""
  @State var ingredientSections: [IngredientSections] = []
  @State var instructions: [Instructions] = []
  @State private var presentingIngredientSheet = false
  @State private var presentingInstructionSheet = false
  @State private var thumbnailURL: String?
  @State private var recipeImage: Image?
  @State private var isAreYouSureYouWantToLeaveAlertPresent = false
  @State private var isEmptyRecipeNameAlertPresent = false
  var addOrEdit: AddOrEditEnum = .addRecipe
  @Environment(\.dismiss)
  var dismiss

  var body: some View {
    VStack {
      Form {
        Section {
          HStack {
            Spacer()
            AddRecipeThumbnailView(
              thumbnailURL: $thumbnailURL,
              recipeID: recipe.id,
              addOrEdit: addOrEdit)
            Spacer()
          }
        }
        .listRowBackground(Color.clear)
        Section {
          TextField("Recipe Name", text: $recipeName)
            .autocorrectionDisabled()
          TextField("Recipe description", text: $recipeDescription, axis: .vertical)
            .lineLimit(5...20)
            .autocorrectionDisabled()
        }
        Section {
          Button {
            presentingIngredientSheet = true
          } label: {
            ButtonLabel(buttonText: "Add Ingredient")
          }.sheet(isPresented: $presentingIngredientSheet) {
            AddIngredientSectionsView(
              ingredientSections: $ingredientSections
            )
          }
          Button {
            presentingInstructionSheet = true
          } label: {
            ButtonLabel(buttonText: "Add Instruction")
          }
          .sheet(isPresented: $presentingInstructionSheet) {
            AddInstructionsListView(instructions: $instructions)
          }
        }
        Section {
          HStack {
            TimePicker(timePickerTitle: "Preparation Time", time: $prepTime)
            Spacer()
            Divider()
            Spacer()
            TimePicker(timePickerTitle: "Cooking Time", time: $cookTime)
          }
          HStack {
            Text("Total Time")
            Spacer()
            Text("\(HandleMeasurement().calculateTotalTime(prepTime: prepTime, cookTime: cookTime))")
          }
          .foregroundStyle(.gray)
        }
        Section {
          TextField("Add video URL", text: $video)
            .textContentType(.URL)
        }
        Section {
          Picker("Number of Served People", selection: $numServing) {
            ForEach(1..<20) { peopleNumber in
              Text("\(peopleNumber)")
                .tag("\(peopleNumber)")
                .frame(maxWidth: 20)
            }
          }
        }
        // Ingredient
        // Instructions
      }
      .onAppear {
        loadRecipe()
        ViewConstants.enableSwipBackGesture = false
      }
      .onDisappear {
        ViewConstants.enableSwipBackGesture = true
      }
      .alert(
        TextsConstants.leavingRecipeConfirmation,
        isPresented: $isAreYouSureYouWantToLeaveAlertPresent) {
          Button("Yes", role: .none) {
            isAreYouSureYouWantToLeaveAlertPresent = false
            if addOrEdit == .addRecipe {
              setToInitialState()
            }
            dismiss()
          }
          Button("No", role: .none) {}
        }
        .alert(
          TextsConstants.pleaseEnterRecipeNameAlertTitle,
          isPresented: $isEmptyRecipeNameAlertPresent,
          actions: {
            Button("OK", role: .none) {
              isEmptyRecipeNameAlertPresent = false
            }
          },
          message: {
            Text(TextsConstants.pleaseEnterRecipeNameAlertMessage)
          })
        .navigationBarBackButtonHidden()
        .navigationTitle(addOrEdit.rawValue)
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) {
            Button(action: {
              if recipeName.isEmpty {
                isEmptyRecipeNameAlertPresent = true
              } else {
                saveRecipe()
              }
            }, label: {
              Text("Save")
            })
          }
          ToolbarItem(placement: .topBarLeading) {
            Button(action: {
              isAreYouSureYouWantToLeaveAlertPresent = true
            }, label: {
              BackNavigationButton()
            })
          }
          //                    KeyboardToolbarItem()
        }
    }
  }
}

extension AddRecipeView {
  private func loadRecipe() {
    recipeName = recipe.tastyRecipe.name
    recipeDescription = recipe.tastyRecipe.description ?? ""
    prepTime = recipe.tastyRecipe.prepTimeMinutes ?? 0
    cookTime = recipe.tastyRecipe.cookTimeMinutes ?? 0
    numServing = recipe.tastyRecipe.numServing
    video = recipe.tastyRecipe.videoURL ?? ""
    ingredientSections = recipe.tastyRecipe.ingredientSections
    instructions = recipe.tastyRecipe.instructions
    thumbnailURL = recipe.tastyRecipe.thumbnailURL
  }

  private func saveRecipe() {
    recipe.tastyRecipe.name = recipeName
    recipe.tastyRecipe.description = recipeDescription
    recipe.tastyRecipe.prepTimeMinutes = prepTime
    recipe.tastyRecipe.cookTimeMinutes = cookTime
    recipe.tastyRecipe.numServing = numServing
    recipe.tastyRecipe.videoURL = video
    recipe.tastyRecipe.ingredientSections = ingredientSections
    recipe.tastyRecipe.instructions = instructions
    if let thumbnailURL = thumbnailURL {
      if !thumbnailURL.starts(with: "https") {
        recipe.tastyRecipe.thumbnailURL = recipe.id
        recipe.tastyRecipe.beautyURL = recipe.id
        recipe.tastyRecipe.imageDataURL = nil
      }
    }
    recalculateComponentPosition()
    recipeStore.saveChangesOnRecipe(recipe)
  }

  private func setToInitialState() {
    print("setToInitialState")
    recipe.tastyRecipe.name = ""
    recipe.tastyRecipe.description = ""
    recipe.tastyRecipe.prepTimeMinutes = nil
    recipe.tastyRecipe.cookTimeMinutes = nil
    recipe.tastyRecipe.numServing = 0
    recipe.tastyRecipe.videoURL = ""
    recipe.tastyRecipe.ingredientSections = []
    recipe.tastyRecipe.thumbnailURL = ""
  }

  func recalculateComponentPosition() {
    for ingredientSection in ingredientSections {
      var components = ingredientSection.components
      for _ in components {
        for index in 0..<components.count {
          components[index].position = index + 1
        }
      }
    }
  }
}

#Preview {
  struct Preview: View {
    private static let tastyRecipe = TastyJSONSample().getRecipeFromJSONFile()?.recipes[0]
    @State var recipe = Recipe(tastyRecipe: tastyRecipe, recipeType: .myRecipe)
    var body: some View {
      AddRecipeView(recipe: $recipe)
        .environmentObject(RecipesStore())
    }
  }
  return Preview()
}
