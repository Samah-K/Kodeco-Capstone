//
//  CapstoneCookbookTests.swift
//  CapstoneCookbookTests
//
//  Created by Samah Ktaifan on 02/07/2024.
//

import XCTest
@testable import Capstone_Cookbook

final class CapstoneCookbookTests: XCTestCase {
  override func setUpWithError() throws {
  }

  override func tearDownWithError() throws {
  }

  func test_RecipeStore_Search_NoSearchQuery() async throws {
    let recipesStore = RecipesStore()
    do {
      try await recipesStore.fetchRecipesFromTasty(searchQuery: "")
      XCTAssertEqual(recipesStore.tastyRecipes.count, 0)
    } catch {
      XCTAssertNotNil(error)
      XCTAssertEqual(error.localizedDescription, NetworkError.invalidSearchQuery.localizedDescription)
    }
  }

  func test_RecipeStore_Search_AppleSearchQuery_TastyRecipeHasDats() async throws {
    // Given
    let recipesStore = RecipesStore()
    // When
    do {
      try await recipesStore.fetchRecipesFromTasty(searchQuery: "Apple")
      // Then
      XCTAssertNotNil(recipesStore.tastyRecipes)
      XCTAssertNotEqual(recipesStore.tastyRecipes.count, 0)
    } catch {
      XCTAssertNil(error)
    }
  }

  func test_TastyAPI_GetListOfRecipes_HasData() async throws {
    // Int = 0, size: Int = 10, searchQuery: String? = "", tags: String? = ""
    let from = 0
    let size = 10
    let searchQuery = "Apple"
    let tags = ""

    let tastyNetworkService = TastyNetworkService()

    let tastyData = try await tastyNetworkService.getListOfRecipes(
      from: from,
      size: size,
      searchQuery: searchQuery,
      tags: tags)
    XCTAssertNotNil(tastyData)
    XCTAssertNotEqual(tastyData.count, 0)
  }

  func test_RecipeStore_AddRecipeToCookBook_RecipeIsAddedToCookBook() async throws {
    // Given
    let recipesStore = RecipesStore(fetchFromFile: false)
    // When
    do {
      try await recipesStore.fetchRecipesFromTasty(searchQuery: "Apple")
      // Then
      if !recipesStore.tastyRecipes.isEmpty {
        XCTAssertEqual(recipesStore.myRecipes.count, 0)
        let randomRecipeIndex = Int.random(in: 0..<recipesStore.tastyRecipes.count)
        let randomRecipe = recipesStore.tastyRecipes[randomRecipeIndex]
        _ = recipesStore.addRecipeToMyCookBook(recipeID: randomRecipe.id)
        XCTAssertEqual(recipesStore.myRecipes.count, 1)
        XCTAssertEqual(recipesStore.myRecipes[0].id, randomRecipe.id)
        XCTAssertEqual(recipesStore.myRecipes[0].isRecipeAddedToMyCookbook, true)
      }
    } catch {
      XCTAssertNil(error)
    }
  }

  func convertUnitAmount(from unitAmount: UnitAmounts) async throws -> UnitAmounts {
    let spoonacularNetworkService = SpoonacularNetworkService()
    let resultUnitAmount = try await spoonacularNetworkService.covertingAmounts(
      ingredient: unitAmount.ingredient ?? "flour",
      sourceUnit: unitAmount.sourceUnit,
      sourceAmount: unitAmount.sourceAmount,
      targetUnit: unitAmount.targetUnit)
    return resultUnitAmount
  }

  func test_SpoonacularAPI_CovertingAmounts_ConvertsFromGramToCup() async throws {
    // Given that 1 Cup of Flour in Grams: 120 g (from Google)
    let sourceUnitAmount = UnitAmounts(
      sourceUnit: UnitsName.gram.rawValue,
      sourceAmount: 120,
      targetUnit: UnitsName.cup.rawValue,
      targetAmount: 0.0,
      ingredient: "Flour")
    let spoonacularNetworkService = SpoonacularNetworkService()
    let resultUnitAmount = try await convertUnitAmount(from: sourceUnitAmount)

    XCTAssertNotNil(resultUnitAmount)
    XCTAssertEqual(resultUnitAmount.ingredient, sourceUnitAmount.ingredient)
    XCTAssertEqual(resultUnitAmount.sourceUnit, sourceUnitAmount.sourceUnit)
    XCTAssertEqual(resultUnitAmount.sourceAmount, sourceUnitAmount.sourceAmount)
    XCTAssertEqual(resultUnitAmount.targetUnit, sourceUnitAmount.targetUnit)
    XCTAssertNotEqual(resultUnitAmount.targetAmount, 0)
    XCTAssertEqual(resultUnitAmount.targetAmount, 1, accuracy: 0.1)
  }

  func test_SpoonacularAPI_CovertingAmounts_convertsFromCupToGram() async throws {
    // Given that 1 Cup of Flour in Grams: 120 g (from Google)
    let sourceUnitAmount = UnitAmounts(
      sourceUnit: UnitsName.cup.rawValue,
      sourceAmount: 1,
      targetUnit: UnitsName.gram.rawValue,
      targetAmount: 0.0,
      ingredient: "Flour")
    let spoonacularNetworkService = SpoonacularNetworkService()
    let resultUnitAmount = try await convertUnitAmount(from: sourceUnitAmount)

    XCTAssertNotNil(resultUnitAmount)
    XCTAssertEqual(resultUnitAmount.ingredient, sourceUnitAmount.ingredient)
    XCTAssertEqual(resultUnitAmount.sourceUnit, sourceUnitAmount.sourceUnit)
    XCTAssertEqual(resultUnitAmount.sourceAmount, sourceUnitAmount.sourceAmount)
    XCTAssertEqual(resultUnitAmount.targetUnit, sourceUnitAmount.targetUnit)
    XCTAssertNotEqual(resultUnitAmount.targetAmount, 0)
    XCTAssertEqual(resultUnitAmount.targetAmount, 120, accuracy: 10)
  }

  func test_HandleMeasurement_ConverteQunatity() {
    let arrayOfVulgarFraction = [
      "½", "⅓", "⅔", "¼", "¾", "⅕", "⅖", "⅗",
      "⅘", "⅙", "⅚", "⅐", "⅛", "⅜", "⅝", "⅞",
      "⅑", "⅒"
    ]

    let handleMeasurement = HandleMeasurement()
    let index = Int.random(in: 0..<arrayOfVulgarFraction.count)
    let randomVulgarFraction = arrayOfVulgarFraction[index]
    let result = handleMeasurement.convertQuantity(quantity: randomVulgarFraction)

    XCTAssertEqual(result, handleMeasurement.vulgarFractionDic[randomVulgarFraction])
  }

  func test_HandleMeasurement_ConverteQunatity_StressTesting() {
    for _ in 1..<50 {
      test_HandleMeasurement_ConverteQunatity()
    }
  }

  func test_HandleMeasurement_GetIngredientDescription() {
//    let handleMeasurement = HandleMeasurement()
//    var ingredient = EmptyObjects().createEmptyIngredient()
//    var measurement = EmptyObjects().createEmptyMeasurement()
//    let ingredientName = "Apple"
//    ingredient.name = ingredientName
//
//    let selectRandomUnitName = UnitsName.allCases[Int.random(in: 0..<UnitsName.allCases.count)]
//
//    let unit = UnitsConstant().dictionary[selectRandomUnitName]
//    XCTAssertNotNil(unit)
//    if let unit = unit {
//      measurement.unit = unit
//      let description = handleMeasurement.getIngredientDescription(ingredient: ingredient, measurement: measurement)
//      if measurement.unit.system == "none" {
//        XCTAssertEqual(description, ingredient.name)
//      } else {
//        let quantity = handleMeasurement.convertQuantity(quantity: measurement.quantity)
//        XCTAssertEqual(description, "\(quantity) \(measurement.unit.abbreviation) of \(ingredient.name)" )
//      }
//    }
  }

  func testPerformanceExample() throws {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
}
