//
//  AddIngredientAndMeasurementView.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 15/07/2024.
//

import SwiftUI

struct AddIngredientView: View {
  @Binding var ingredient: Ingredient
  @Binding var measurement: [Measurement]
  @State var ingredientName = ""
  @State var ingredientPlural = ""
  @State var ingredientSignal = ""
  @State var quantity = 0.0
  @State var unitString = UnitsName.none
  @State var unit: Unit?
  @State var system = UnitsSystem.metric.rawValue
  @State var systemGroup = UnitSystemGroup.metricOrImperial.rawValue
  @State var isHowPopOverPresent = false
  var body: some View {
    ZStack(alignment: .center) {
      VStack {
        Form {
          Section {
            TextField("Ingredient Name", text: $ingredientName)
            TextField("Ingredient Name (Singular)", text: $ingredientSignal)
            TextField("Ingredient Name (Plural)", text: $ingredientPlural)
          } header: {
            Text("Ingredient Name")
          } footer: {
            Text("Plural and Singular are optional.")
              .font(.caption)
          }
          MeasurementView(
            measurement: $measurement,
            ingredient: $ingredient,
            isHowPopOverPresent: $isHowPopOverPresent)
        }
      }
      VStack {
        if isHowPopOverPresent {
          DescriptionPopup(
            descriptionShowingModal: $isHowPopOverPresent,
            descriptionAnimation: .constant(false),
            recipeDescription: TextsConstants().measurementHowTo)
        }
      }
      .onAppear {
        self.ingredientName = ingredient.name
        self.ingredientPlural = ingredient.displayPlural ?? ingredient.name
        self.ingredientSignal = ingredient.displaySingular ?? ingredient.name
        measurement.forEach { measurement in
          print(measurement)
        }
        self.quantity = HandleMeasurement().convertQuantity(quantity: measurement[0].quantity)
        self.unit = measurement[0].unit
        self.unitString = UnitsName(rawValue: unit?.name ?? "none") ?? .none
      }
      .navigationTitle("Add New Ingredient")
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button(action: {
          }, label: {
            Text("Save")
          })
        }
      }
    }
  }
}

protocol CalculateAmountProtocol {
  func updateUI(to unitAmount: UnitAmounts, _ toSystem: UnitsSystem)
}

struct MeasurementView: View {
  @EnvironmentObject var recipeStore: RecipesStore
  @Binding var measurement: [Measurement]
  @Binding var ingredient: Ingredient
  @Binding var isHowPopOverPresent: Bool
  @State var unit: Unit?
  @State var systemGroup = UnitSystemGroup.metricOrImperial.rawValue.uppercased()
  @State var metricSystem = MeasurementAndUnit(quantity: 0, unit: .gram)
  @State var imperialSystem = MeasurementAndUnit(quantity: 0, unit: .cup)
  @State var noneSystem = MeasurementAndUnit(quantity: 0, unit: .none)

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
        HStack {
          Spacer()
          Button(
            action: {
              print("Calculate metrics")
              calculateAmount(
                from: imperialSystem.quantity,
                imperialSystem.unit,
                to: metricSystem.unit)
            }, label: {
              ButtonLabel(buttonText: "Calculate\n\(metricSystem.unit)", padding: 15.0, font: .callout)
            })
          Button(
            action: {
              print("Calculate imperial")
              calculateAmount(
                from: metricSystem.quantity,
                metricSystem.unit,
                to: imperialSystem.unit)
            }, label: {
              ButtonLabel(buttonText: "Calculate\n\(imperialSystem.unit)", padding: 15.0, font: .callout)
            })
        }
        .padding(.top, 10)
      }
    }
    .onAppear {
      print("onAppear: MeasurementView")
      setPropertiesOnAppear()
    }
  }
  func calculateAmount(from amount: Double, _ fromUnit: UnitsName, to toUnit: UnitsName) {
    // TODO: using Spooncular
    recipeStore.convertAmount(of: ingredient.name, from: amount, fromUnit, to: toUnit, delegate: self)
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
}

extension MeasurementView: CalculateAmountProtocol {
  func updateUI(to unitAmount: UnitAmounts, _ toSystem: UnitsSystem) {
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
    @State var ingredient = recipe.tastyRecipe.ingredientSections[0].components[1].ingredient
    @State var measurement = recipe.tastyRecipe.ingredientSections[0].components[0].measurements
    @State var isHowPopOverPresent = false
    var body: some View {
      return NavigationStack {
        VStack {
          AddIngredientView(ingredient: $ingredient, measurement: $measurement)
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
    @State var ingredient = recipe.tastyRecipe.ingredientSections[0].components[1].ingredient
    @State var measurement = recipe.tastyRecipe.ingredientSections[0].components[0].measurements
    @State var isHowPopOverPresent = false
    var body: some View {
      return NavigationStack {
        VStack {
          MeasurementView(measurement: $measurement, ingredient: $ingredient, isHowPopOverPresent: $isHowPopOverPresent)
            .environmentObject(RecipesStore())
        }
      }
    }
  }
  return Preview()
}
