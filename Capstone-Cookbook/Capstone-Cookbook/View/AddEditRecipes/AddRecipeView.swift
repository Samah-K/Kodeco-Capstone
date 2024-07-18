//
//  AddRecipe.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 08/07/2024.
//

import SwiftUI
import PhotosUI

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
  @State private var presentingIngredientSheet = false
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
              recipeID: recipe.id)
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
          }
          .sheet(isPresented: $presentingIngredientSheet) {
            AddIngredientSectionsView(
              ingredientSections: $ingredientSections
            )
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
        recipeName = recipe.tastyRecipe.name
        recipeDescription = recipe.tastyRecipe.description ?? ""
        prepTime = recipe.tastyRecipe.prepTimeMinutes ?? 0
        cookTime = recipe.tastyRecipe.cookTimeMinutes ?? 0
        numServing = recipe.tastyRecipe.numServing
        video = recipe.tastyRecipe.videoURL ?? ""
        ingredientSections = recipe.tastyRecipe.ingredientSections
        thumbnailURL = recipe.tastyRecipe.thumbnailURL
      }
      .alert(
        TextsConstants().leavingRecipeConfirmation,
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
          TextsConstants().pleaseEnterRecipeNameAlertTitle,
          isPresented: $isEmptyRecipeNameAlertPresent,
          actions: {
            Button("OK", role: .none) {
              isEmptyRecipeNameAlertPresent = false
            }
          },
          message: {
            Text(TextsConstants().pleaseEnterRecipeNameAlertMessage)
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
          //          KeyboardToolbarItem()
        }
    }
  }

  private func saveRecipe() {
    recipe.tastyRecipe.name = recipeName
    recipe.tastyRecipe.description = recipeDescription
    recipe.tastyRecipe.prepTimeMinutes = prepTime
    recipe.tastyRecipe.cookTimeMinutes = cookTime
    recipe.tastyRecipe.numServing = numServing
    recipe.tastyRecipe.videoURL = video
    recipe.tastyRecipe.ingredientSections = ingredientSections
    if let thumbnailURL = thumbnailURL {
      print(thumbnailURL)
      recipe.tastyRecipe.thumbnailURL = recipe.id
      recipe.tastyRecipe.beautyURL = recipe.id
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

struct TimePicker: View {
  @State private var hours: Int = 0
  @State private var minutes: Int = 0
  var timePickerTitle: String
  @Binding var time: Int // in minutes: (hours * 60 + minutes)
  var body: some View {
    VStack(alignment: .center, spacing: 10) {
      Text("\(timePickerTitle)")
      HStack {
        VStack(spacing: 3) {
          Picker("Hours", selection: $hours) {
            ForEach(0..<11) { hour in
              Text("\(hour)")
                .tag("\(hour)")
            }
          }
          .pickerStyle(.wheel)
          .frame(maxWidth: 50, maxHeight: 100)
          Text("hours")
            .font(.caption)
            .opacity(0.5)
        }

        VStack(spacing: 3) {
          Picker("Minutes", selection: $minutes) {
            ForEach(0..<60) { minutes in
              Text("\(minutes)")
                .tag("(minutes)")
            }
          }
          .pickerStyle(.wheel)
          .frame(maxWidth: 50, maxHeight: 100)
          Text("minutes")
            .font(.caption)
            .opacity(0.5)
        }
      }
      .onChange(of: hours) {
        calculateTime()
      }
      .onChange(of: minutes) {
        calculateTime()
      }
      .onAppear {
        hours = time / 60
        minutes = time % 60
      }
    }
  }
  private func calculateTime() {
    time = hours * 60 + minutes
  }
}

#Preview("TimePicker") {
  struct Preview: View {
    @State var timeInt = 260
    var body: some View {
      TimePicker(timePickerTitle: "Prep Time", time: $timeInt)
    }
  }
  return Preview()
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


// file:///var/mobile/Containers/Data/Application/16936438-A9E7-4388-86E7-9B0584B654DB/Documents/


// file:///Users/samahktaifan/Library/Developer/CoreSimulator/Devices/CBBC831E-805D-4FEF-B156-A00FD6141A0A/data/Containers/Data/Application/C02BF1E7-899B-4284-B2B7-5CAE4FD513B0/Documents/

///Users/samahktaifan/Library/Developer/CoreSimulator/Devices/CBBC831E-805D-4FEF-B156-A00FD6141A0A/data/Containers/Data/Application/EC771B7D-1F61-4EB6-ACCA-18115D6560E0/Documents/Image-DC48EE96-06E8-4538-8CFB-D168ADF9D218.jpg


/// var/mobile/Containers/Data/Application/5EB8A798-0945-42B8-83FC-E29C4F14831F/Documents/Image-5E5ADE34-0E97-47A3-8FB6-99D491582DD7.jpg
// file:///var/mobile/Containers/Data/Application/5EB8A798-0945-42B8-83FC-E29C4F14831F/Documents/
