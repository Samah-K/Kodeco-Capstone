//
//  MeasurementView.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 20/07/2024.
//

import SwiftUI

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
  @State private var systemGroup = UnitSystemGroup.metricOrImperial.rawValue.uppercased()
  @State private var metricSystem = MeasurementAndUnit(quantity: 0, unit: .gram)
  @State private var imperialSystem = MeasurementAndUnit(quantity: 0, unit: .cup)
  @State private var noneSystem = MeasurementAndUnit(quantity: 0, unit: .none)
  @State private var showProgressView = false
  @State private var isCalculateAmountAlertPresent = false
  @State private var errorTitle = ""
  @State private var errorMessage = ""
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
        HStack(spacing: 10) {
          Text("Measurements")
          if showProgressView {
            ProgressView()
          }
        }
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
                ButtonLabel(buttonText: "Calculate\n\(metricSystem.unit)", padding: 15.0, font: .callout.smallCaps())
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
                ButtonLabel(buttonText: "Calculate\n\(imperialSystem.unit)", padding: 15.0, font: .callout.smallCaps())
              })
            .disabled(showProgressView)
          }
          .padding(.top, 10)
        }
      }
    }
    .onAppear {
      setPropertiesOnAppear()
    }
    .alert(errorTitle, isPresented: $isCalculateAmountAlertPresent, actions: {
      Button("OK", role: .cancel) {
        isCalculateAmountAlertPresent = false
      }
    }, message: {
      Text("\(errorMessage)")
    })
    .onChange(of: shouldSaveComponent) { _, newValue in
      if newValue {
        print("Saving Measurements")
        self.saveMeasurement()
        shouldSaveComponent = false
      }
    }
  }
}

extension MeasurementView {
  private func calculateAmount(of ingredientName: String, from amount: Double, _ fromUnit: UnitsName, to toUnit: UnitsName) {
    if !showProgressView {
      if !ingredientName.isEmpty && amount != 0.0 {
        showProgressView = true
        recipeStore.convertAmount(of: ingredientName, from: amount, fromUnit, to: toUnit, delegate: self)
      }
    }
  }
  private func setPropertiesOnAppear() {
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

  private func saveMeasurement() {
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
    errorTitle = TextsConstants.failedToConvetAmountAlertTitle
    errorMessage = TextsConstants.failedToConvetAmountAlertMessage
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

  func showErrors(error: String) {
    isCalculateAmountAlertPresent = true
    showProgressView = false
    errorTitle = "Something went wrong"
    errorMessage = error
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
