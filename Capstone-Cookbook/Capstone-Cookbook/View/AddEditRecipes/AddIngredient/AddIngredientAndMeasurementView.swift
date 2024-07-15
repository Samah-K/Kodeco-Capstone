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
            popText: TextsConstants().measurementHowTo)
        }
      }
      .onAppear {
        self.ingredientName = ingredient.name
        self.ingredientPlural = ingredient.displayPlural ?? ingredient.name
        self.ingredientSignal = ingredient.displaySingular ?? ingredient.name
      }
      .interactiveDismissDisabled()
      .navigationTitle(addOrEdit == .addRecipe ? "Add New Ingredient" : "Edit Ingredient")
      .navigationBarBackButtonHidden()
      .alert(
        TextsConstants().leavingIngredientConfirmation,
        isPresented: $isAreYouSureYouWantToLeaveAlertPresent) {
          Button("Yes", role: .none) { dismiss() }
          Button("No", role: .cancel) {}
      }
      .alert(
        TextsConstants().pleaseEnterIngredientNameAlertTitle,
        isPresented: $isEnterIngredientNameAlertPresent,
        actions: {
          Button("OK", role: .cancel) { isEnterIngredientNameAlertPresent = false }
        }, message: {
          Text(TextsConstants().pleaseEnterIngredientNameAlertMessage)
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
      }
    }
  }
  func saveIngredientOnly() {
    ingredient.name = self.ingredientName
    ingredient.displayPlural = self.ingredientPlural.isEmpty ? self.ingredientName : self.ingredientPlural
    ingredient.displaySingular = self.ingredientPlural.isEmpty ? self.ingredientName : self.ingredientSignal
  }
}

struct MeasurementView: View {
  @EnvironmentObject var recipeStore: RecipesStore
  let componentID: String
  @State var measurement: [Measurement]
  @Binding var ingredient: Ingredient
  @Binding var ingredientName: String
  var addOrEdit: AddOrEditEnum
  @Binding var isHowPopOverPresent: Bool
  @Binding var shouldSaveComponent: Bool
  @State var unit: Unit?
  @State var systemGroup = UnitSystemGroup.metricOrImperial.rawValue.uppercased()
  @State var metricSystem = MeasurementAndUnit(quantity: 0, unit: .gram)
  @State var imperialSystem = MeasurementAndUnit(quantity: 0, unit: .cup)
  @State var noneSystem = MeasurementAndUnit(quantity: 0, unit: .none)
  @State var showProgressView = false
  @State var isCalculateAmountAlertPresent = false
  var delegate: UpdateIngredientComponent?

  var body: some View {
    Section {
      Picker("System", selection: $systemGroup) {
        Text(UnitSystemGroup.metricOrImperial.rawValue.uppercased())
          .tag(UnitSystemGroup.metricOrImperial.rawValue.uppercased())
        Text(UnitSystemGroup.none.rawValue.uppercased())
          .tag(UnitSystemGroup.none.rawValue.uppercased())
      }
      .pickerStyle(.segmented)
      if systemGroup.capitalized == UnitSystemGroup.metricOrImperial.rawValue {
        MeasurementAndUnitView(measurementAndUnit: $metricSystem, unitSystem: .metric)
        MeasurementAndUnitView(measurementAndUnit: $imperialSystem, unitSystem: .imperial)
      } else {
        MeasurementAndUnitView(measurementAndUnit: $noneSystem, unitSystem: .none)
      }
    } header: {
      HStack {
        Text("Measurements")
        Spacer()
        Button(action: {
          isHowPopOverPresent = true
        }, label: {
          Image(systemName: "questionmark.circle.fill")
        })
      }
    } footer: {
      if systemGroup.capitalized == UnitSystemGroup.metricOrImperial.rawValue {
        VStack {
          HStack {
            Spacer()
            Button(
              action: {
                print("Calculate metrics")
                calculateAmount(
                  of: ingredientName,
                  from: imperialSystem.quantity,
                  imperialSystem.unit,
                  to: metricSystem.unit)
              }, label: {
                ButtonLabel(buttonText: "Calculate\n\(metricSystem.unit)", padding: 15.0, font: .callout)
              })
            .disabled(showProgressView)
            Button(
              action: {
                print("Calculate imperial")
                calculateAmount(
                  of: ingredientName,
                  from: metricSystem.quantity,
                  metricSystem.unit,
                  to: imperialSystem.unit)
              }, label: {
                ButtonLabel(buttonText: "Calculate\n\(imperialSystem.unit)", padding: 15.0, font: .callout)
              })
            .disabled(showProgressView)
          }
          .padding(.top, 10)
          if showProgressView {
            ProgressView()
              .padding(.top, 10)
          }
        }
      }
    }
    .onAppear {
      setPropertiesOnAppear()
    }
    .alert(TextsConstants().failedToConvetAmountAlertTitle, isPresented: $isCalculateAmountAlertPresent, actions: {
      Button("OK", role: .cancel) {
        isCalculateAmountAlertPresent = false
      }
    }, message: {
      Text("\(TextsConstants().failedToConvetAmountAlertMessage)")
    })
    .onChange(of: shouldSaveComponent) { _, newValue in
      if newValue {
        print("Saving Measurements")
        self.saveMeasurement()
        shouldSaveComponent = false
      }
    }
  }
  func calculateAmount(of ingredientName: String, from amount: Double, _ fromUnit: UnitsName, to toUnit: UnitsName) {
    if !showProgressView {
      if !ingredientName.isEmpty && amount != 0.0 {
        showProgressView = true
        recipeStore.convertAmount(of: ingredientName, from: amount, fromUnit, to: toUnit, delegate: self)
      }
    }
  }
  func setPropertiesOnAppear() {
    if measurement.count == 2 {
      systemGroup = UnitSystemGroup.metricOrImperial.rawValue.uppercased()
      var metricQuantity = ""
      var metricUnit = UnitsName.gram
      var imperialQuantity = ""
      var imperialUnit = UnitsName.cup
      if measurement[0].unit.system == "metric" {
        metricQuantity = measurement[0].quantity
        metricUnit = UnitsName(rawValue: measurement[0].unit.name) ?? .none
        if measurement[1].unit.system == "imperial" {
          imperialQuantity = measurement[1].quantity
          imperialUnit = UnitsName(rawValue: measurement[1].unit.name) ?? .none
        }
      } else if measurement[0].unit.system == "imperial" {
        imperialQuantity = measurement[0].quantity
        imperialUnit = UnitsName(rawValue: measurement[0].unit.name) ?? .none
        if measurement[1].unit.system == "metric" {
          metricQuantity = measurement[1].quantity
          metricUnit = UnitsName(rawValue: measurement[1].unit.name) ?? .none
        }
      }
      metricSystem = MeasurementAndUnit(
        quantity: HandleMeasurement().convertQuantity(quantity: metricQuantity),
        unit: metricUnit)
      imperialSystem = MeasurementAndUnit(
        quantity: HandleMeasurement().convertQuantity(quantity: imperialQuantity),
        unit: imperialUnit)
    } else {
      systemGroup = UnitSystemGroup.none.rawValue.uppercased()
      noneSystem = MeasurementAndUnit(
        quantity: HandleMeasurement().convertQuantity(quantity: measurement[0].quantity),
        unit: UnitsName(rawValue: measurement[0].unit.name) ?? .none)
    }
  }

  func saveMeasurement() {
    if systemGroup == UnitSystemGroup.none.rawValue.uppercased() {
      var noneMeasurement = EmptyObjects().createEmptyMeasurement()
      noneMeasurement.quantity = "\(noneSystem.quantity)"
      if let unitInfo = noneSystem.unit.getUnitInfo() {
        noneMeasurement.unit = unitInfo
      }
      measurement = [noneMeasurement]
    } else {
      var metricMeasurement = EmptyObjects().createEmptyMeasurement()
      metricMeasurement.quantity = "\(metricSystem.quantity)"
      if let unitInfo = metricSystem.unit.getUnitInfo() {
        metricMeasurement.unit = unitInfo
      }
      var imperialMeasurement = EmptyObjects().createEmptyMeasurement()
      imperialMeasurement.quantity = "\(imperialSystem.quantity)"
      if let unitInfo = imperialSystem.unit.getUnitInfo() {
        imperialMeasurement.unit = unitInfo
      }
      measurement = [metricMeasurement, imperialMeasurement]
    }
    if let delegate = delegate {
      delegate.saveComponent(
        componentID: componentID,
        ingredient: ingredient,
        measurement: measurement,
        shouldAddComponent: addOrEdit)
    } else {
      print("Couldn't save - Please pass in a delegate")
    }
  }
}

extension MeasurementView: CalculateAmountProtocol {
  func noResultWasFound() {
    isCalculateAmountAlertPresent = true
    showProgressView = false
  }

  func updateUI(to unitAmount: UnitAmounts, _ toSystem: UnitsSystem) {
    showProgressView = false
    if toSystem == .metric {
      // update the metric value
      metricSystem.quantity = unitAmount.targetAmount
    } else if toSystem == .imperial {
      // update the imperial value
      imperialSystem.quantity = unitAmount.targetAmount
    }
  }
}

struct MeasurementAndUnitView: View {
  @Binding var measurementAndUnit: MeasurementAndUnit
  let unitSystem: UnitsSystem
  var body: some View {
    VStack {
      HStack {
        TextField("Quantity", value: $measurementAndUnit.quantity, format: .number)
          .autocorrectionDisabled()
          .keyboardType(.decimalPad)
        Spacer()
        Picker("Unit", selection: $measurementAndUnit.unit) {
          if let unitsInSystem = UnitsConstant().unitsInUnitSystems[unitSystem] {
            let sortedUnitsInSystem = unitsInSystem.sorted { $0.rawValue < $1.rawValue }
            ForEach(sortedUnitsInSystem, id: \.self) { unit in
              Text(unit.rawValue)
                .tag(unit.rawValue)
            }
          }
        }
        .labelsHidden()
      }
    }
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

#Preview("MeasurementView") {
  struct Preview: View {
    private static let tastyRecipe = TastyJSONSample().getRecipeFromJSONFile()?.recipes[0]
    private static let recipe = Recipe(tastyRecipe: tastyRecipe, recipeType: .myRecipe)
    private static let component = recipe.tastyRecipe.ingredientSections[0].components[0]
    @State var ingredient = component.ingredient
    var measurement = component.measurements
    @State var isHowPopOverPresent = false
    @State var shouldSaveComponent = true
    var body: some View {
      return NavigationStack {
        VStack {
          MeasurementView(
            componentID: Preview.component.id.uuidString,
            measurement: measurement,
            ingredient: $ingredient,
            ingredientName: $ingredient.name,
            addOrEdit: .editRecipe,
            isHowPopOverPresent: $isHowPopOverPresent,
            shouldSaveComponent: $shouldSaveComponent)
        }
      }
    }
  }
  return Preview()
}
