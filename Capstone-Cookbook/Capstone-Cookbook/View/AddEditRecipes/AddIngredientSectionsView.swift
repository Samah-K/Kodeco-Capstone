//
//  AddIngredientView.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 12/07/2024.
//

import SwiftUI
// [½, ⅓, ⅔, ¼, ¾, ⅕, ⅖, ⅗, ⅘, ⅙, ⅚, ⅐, ⅛, ⅜, ⅝,⅞, ⅑, ⅒]
let vulgarFractionDic: [String: Double] = [
  "½": 1.0 / 2.0,
  "⅓": 1.0 / 3.0,
  "⅔": 2.0 / 3.0,
  "¼": 1.0 / 4.0,
  "¾": 3.0 / 4.0,
  "⅕": 1.0 / 5.0,
  "⅖": 2.0 / 5.0,
  "⅗": 3.0 / 5.0,
  "⅘": 4.0 / 5.0,
  "⅙": 1.0 / 6.0,
  "⅚": 5.0 / 6.0,
  "⅐": 1.0 / 7.0,
  "⅛": 1.0 / 8.0,
  "⅜": 3.0 / 8.0,
  "⅝": 5.0 / 8.0,
  "⅞": 7.0 / 8.0,
  "⅑": 1.0 / 9.0,
  "⅒": 1.0 / 10.0
]

struct AddIngredientSectionsView: View {
  private let defaultSectionName = "Section"
  @Binding var ingredientSections: [IngredientSections]
  @State private var isAlertShown = false // Add sections name
  @State private var sectionName = ""

  var body: some View {
    NavigationStack {
      VStack {
        Form {
          Group {
            Text("Divide your ingredients into sections.")
            + Text("\nFor example, a section for the `Pie Dough`")
            + Text("and another for the `Filling`")
          }
          .listRowBackground(Color.clear)
          ForEach($ingredientSections) { $section in
            Section {
              VStack {
                NavigationLink {
                  IngredientListView(
                    sectionName: $section.name,
                    components: $section.components,
                    sectionNameInAlert: section.name ?? defaultSectionName)
                } label: {
                  Text(section.name ?? defaultSectionName)
                }
              }
            }
          }
        }
      }
      .navigationTitle("Ingredient List")
      .alert("Add Section", isPresented: $isAlertShown, actions: {
        TextField("Section Name", text: $sectionName)
        Button("OK", role: .none) {
          addSection()
        }
      }, message: {
        Text("Add Section to add Ingredient to it")
      })
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button(action: {
            // Add
            isAlertShown = true
          }, label: {
            Image(systemName: "plus.square.on.square")
          })
        }
      }
    }
  }
  private func addSection() {
    guard !sectionName.isEmpty else { return }
    let newSection = IngredientSections(components: [], name: sectionName, position: ingredientSections.count + 1)
    ingredientSections.append(newSection)
  }
}

struct IngredientListView: View {
  @Binding var sectionName: String?
  @Binding var components: [Component]
  // Don't update the section name immediately while the user still writing, only update it when user clicks `OK`, since the user can change their mind, and decide that they don't want to update the section name now
  @State var sectionNameInAlert: String
  @State private var isAlertShown = false // Add sections name
  var body: some View {
    Form {
      Section {
        VStack {
          HStack {
            Button(action: {
              // Edit Section name
              isAlertShown = true
            }, label: {
              HStack {
                Image(systemName: "pencil.line")
                Text("\(sectionName ?? "Section")")
              }
            })
          }
          .alert("Edit Section Name", isPresented: $isAlertShown, actions: {
            TextField("Section Name", text: $sectionNameInAlert)
            Button("OK", role: .none) {
              isAlertShown = false
              sectionName = sectionNameInAlert
            }
            Button("Cancel", role: .cancel) {}
          }, message: {
            Text("Add Section to add Ingredient to it")
          })
        }
      }.listRowBackground(Color.clear)
      Section {
        List {
          ForEach($components) { comp in
            NavigationLink {
              AddIngredientView(
                ingredient: comp.ingredient,
                measurement: comp.measurements)
            } label: {
              Text("\(HandleMeasurement().getIngredientDescription(ingredient: comp.wrappedValue.ingredient, measurement: comp.wrappedValue.measurements[0]))")
            }
          }
          .onMove { indices, newOffset in
            components.move(fromOffsets: indices, toOffset: newOffset)
          }
          .onDelete { indexSet in
            components.remove(atOffsets: indexSet)
          }
        }
      }
    }
    .onAppear {
      print("IngredientListView: onAppear")
    }
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        NavigationLink {
          //          AddIngredientView(ingredien/*t: <#Binding<Ingredient>#>, measurement: <#Binding<Measurement>#>)*/
        } label: {
          Image(systemName: "plus")
        }
      }
    }
  }
}

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
          if var unitsInSystem = UnitsConstant().unitsInUnitSystems[unitSystem] {
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

#Preview {
  struct Preview: View {
    @State var section = TastyJSONSample().getRecipeFromJSONFile()?.recipes[0].ingredientSections ?? []
    var body: some View {
      AddIngredientSectionsView(ingredientSections: $section)
    }
  }
  return Preview()
}

#Preview("IngredientListView") {
  struct Preview: View {
    private static let section = TastyJSONSample().getRecipeFromJSONFile()?.recipes[0].ingredientSections.first
    @State var components = Preview.section?.components ?? []
    @State var sectionName = Preview.section?.name
    var body: some View {
      return NavigationStack {
        VStack {
          IngredientListView(
            sectionName: $sectionName,
            components: $components,
            sectionNameInAlert: sectionName ?? "Section")
        }
      }
    }
  }
  return Preview()
}

#Preview("AddIngredientView") {
  struct Preview: View {
    private static let tastyRecipe = TastyJSONSample().getRecipeFromJSONFile()?.recipes[0]
    private static let recipe = Recipe(tastyRecipe: tastyRecipe, recipeType: .myRecipe)
    @State var ingredient = recipe.tastyRecipe.ingredientSections[0].components[1].ingredient
    @State var measurement = recipe.tastyRecipe.ingredientSections[0].components[0].measurements
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
