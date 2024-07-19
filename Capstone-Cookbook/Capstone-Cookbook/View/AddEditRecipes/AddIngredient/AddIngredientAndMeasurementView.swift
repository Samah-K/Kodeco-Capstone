//
//  AddIngredientAndMeasurementView.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 15/07/2024.
//

import SwiftUI

struct AddIngredientView: View {
  let componentID: String
  @State var ingredient: Ingredient
  @State var measurement: [Measurement]
  var addOrEdit: AddOrEditEnum
  @State var ingredientName = ""
  @State var ingredientPlural = ""
  @State var ingredientSignal = ""
  @State var isHowPopOverPresent = false
  @State var isAreYouSureYouWantToLeaveAlertPresent = false
  @State var isEnterIngredientNameAlertPresent = false
  @State var shouldSaveComponent = false
  var delegate: UpdateIngredientComponent?
  @Environment(\.dismiss)
  var dismiss
  var body: some View {
    ZStack(alignment: .center) {
      VStack {
        Form {
          Section {
            TextField("Ingredient Name", text: $ingredientName)
              .autocorrectionDisabled()
            TextField("Ingredient Name (Singular)", text: $ingredientSignal)
              .autocorrectionDisabled()
            TextField("Ingredient Name (Plural)", text: $ingredientPlural)
              .autocorrectionDisabled()
          } header: {
            Text("Ingredient Name")
          } footer: {
            Text("Plural and Singular are optional.")
              .font(.caption)
          }
          MeasurementView(
            componentID: componentID,
            measurement: measurement,
            ingredient: $ingredient,
            ingredientName: $ingredientName,
            addOrEdit: addOrEdit,
            isHowPopOverPresent: $isHowPopOverPresent,
            shouldSaveComponent: $shouldSaveComponent,
            delegate: delegate)
        }
      }
      VStack {
        if isHowPopOverPresent {
          CustomPopup(
            isPopPresented: $isHowPopOverPresent,
            popText: TextsConstants.measurementHowTo)
        }
      }
      .onAppear {
        self.ingredientName = ingredient.name
        self.ingredientPlural = ingredient.displayPlural ?? ingredient.name
        self.ingredientSignal = ingredient.displaySingular ?? ingredient.name
        ViewConstants.enableSwipBackGesture = false
      }
      .onDisappear {
        ViewConstants.enableSwipBackGesture = true
      }
      .interactiveDismissDisabled()
      .navigationTitle(addOrEdit == .addRecipe ? "Add New Ingredient" : "Edit Ingredient")
      .navigationBarBackButtonHidden()
      .alert(
        TextsConstants.leavingIngredientConfirmation,
        isPresented: $isAreYouSureYouWantToLeaveAlertPresent) {
          Button("Yes", role: .none) { dismiss() }
          Button("No", role: .cancel) {}
      }
      .alert(
        TextsConstants.pleaseEnterIngredientNameAlertTitle,
        isPresented: $isEnterIngredientNameAlertPresent,
        actions: {
          Button("OK", role: .cancel) { isEnterIngredientNameAlertPresent = false }
        }, message: {
          Text(TextsConstants.pleaseEnterIngredientNameAlertMessage)
        })
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button(action: {
            // saving
            if ingredientName.isEmpty {
              isEnterIngredientNameAlertPresent = true
            } else {
              saveIngredientOnly()
              shouldSaveComponent = true // continue saving the measurements too
              dismiss()
            }
          }, label: {
            Text(addOrEdit == .addRecipe ? "Add" : "Save")
          })
        }
        ToolbarItem(placement: .topBarLeading) {
          Button {
            isAreYouSureYouWantToLeaveAlertPresent = true
          } label: {
            BackNavigationButton()
          }
        }
        KeyboardToolbarItem()
      }
    }
  }
}

extension AddIngredientView {
  func saveIngredientOnly() {
    ingredient.name = self.ingredientName
    ingredient.displayPlural = self.ingredientPlural.isEmpty ? self.ingredientName : self.ingredientPlural
    ingredient.displaySingular = self.ingredientPlural.isEmpty ? self.ingredientName : self.ingredientSignal
  }
}

#Preview("AddIngredientView") {
  struct Preview: View {
    private static let tastyRecipe = TastyJSONSample().getRecipeFromJSONFile()?.recipes[0]
    private static let recipe = Recipe(tastyRecipe: tastyRecipe, recipeType: .myRecipe)
    var component = recipe.tastyRecipe.ingredientSections[0].components[0]
    @State var isHowPopOverPresent = false
    var body: some View {
      return NavigationStack {
        VStack {
          AddIngredientView(
            componentID: component.id.uuidString,
            ingredient: component.ingredient,
            measurement: component.measurements,
            addOrEdit: .editRecipe,
            delegate: nil)
          .environmentObject(RecipesStore())
        }
      }
    }
  }
  return Preview()
}
