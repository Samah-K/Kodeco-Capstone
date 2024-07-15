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
            Text("\(calculateTotalTime(prepTime: prepTime, cookTime: cookTime))")
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
      }
      .alert(
        TextsConstants().leavingRecipeConfirmation,
        isPresented: $isAreYouSureYouWantToLeaveAlertPresent) {
          Button("Yes", role: .none) {
            isAreYouSureYouWantToLeaveAlertPresent = false
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
    recalculateComponentPosition()
    recipeStore.saveChangesOnRecipe(recipe)
  }
  private func calculateTotalTime(prepTime: Int, cookTime: Int) -> String {
    let totalTime = prepTime + cookTime
    let hours = totalTime / 60
    let minutes = totalTime % 60
    var minutesText = ""
    var hoursText = ""

    if hours == 1 {
      hoursText = "\(hours) hour"
    } else if hours == 0 {
      hoursText = ""
    } else {
      hoursText = "\(hours) hours"
    }
    if minutes == 1 {
      minutesText = "\(minutes) minute"
    } else if minutes == 0 {
      minutesText = ""
    } else {
      minutesText = "\(minutes) minutes"
    }

    return "\(hoursText) \(minutesText)"
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
