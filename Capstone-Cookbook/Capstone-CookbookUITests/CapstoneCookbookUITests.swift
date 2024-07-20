//
//  CapstoneCookbookUITests.swift
//  CapstoneCookbookUITests
//
//  Created by Samah Ktaifan on 02/07/2024.
//

import XCTest
@testable import Capstone_Cookbook

final class CapstoneCookbookUITests: XCTestCase {
  let app = XCUIApplication()

  override func setUpWithError() throws {
    continueAfterFailure = true
    //    app.launchArguments = ["enable-testing"]
    app.launch()
  }
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  func testExample() throws {
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }

  func startFromOnBoarding() {
    let collectionViewsQuery = app.collectionViews
    let onboardingButton = collectionViewsQuery.buttons["OnboardingButton"]
    if onboardingButton.exists {
      onboardingButton.tap()
    }
  }

  func test_appInitialState_Onboarding() {
    let collectionViewsQuery = XCUIApplication().collectionViews
    let onboardingText = collectionViewsQuery.staticTexts["OnboardingText"]
    let onboardingImage = collectionViewsQuery.images["OnboardingImage"]
    let onboardingButton = collectionViewsQuery.buttons["OnboardingButton"]

    if onboardingButton.exists {
      XCTAssertTrue(onboardingImage.exists)
      XCTAssertTrue(onboardingText.exists)
      XCTAssertTrue(onboardingButton.exists)

      onboardingButton.tap()
      let text = app.staticTexts["\(TextsConstants.emptyCookBook)"]
      XCTAssertTrue(text.exists)
    }
  }
  // After onboarding
  func test_appInitialState_EmptyCookBoard() {
    startFromOnBoarding()
    let image = app.images["\(ImagesConstants.EmptyCookBook)"]
    let text = app.staticTexts["\(TextsConstants.emptyCookBook)"]
    let addRecipeButton = app.buttons["\(TextsConstants.emptyCookBookAddNewRecipes)"]
    let exploreButton = app.staticTexts["\(TextsConstants.emptyCookBookExplore)"]

    XCTAssertTrue(image.exists)
    XCTAssertTrue(text.exists)
    XCTAssertTrue(addRecipeButton.exists)
    XCTAssertTrue(exploreButton.exists)
  }

  func test_appInitialState_TabsExists() {
    startFromOnBoarding()
    let tabBar = app.tabBars["Tab Bar"]
    let tabExplore = tabBar.buttons["Explore"]
    let tabCookBook = tabBar.buttons["CookBook"]

    XCTAssertTrue(tabBar.exists)
    XCTAssertTrue(tabCookBook.exists)
    XCTAssertTrue(tabExplore.exists)
    XCTAssertTrue(tabCookBook.isSelected)
    XCTAssertFalse(tabExplore.isSelected)
  }

  func test_appInitialState_TabsExists_GoToExploreRecipe() {
    startFromOnBoarding()
    let exploreButton = app.staticTexts["\(TextsConstants.emptyCookBookExplore)"]
    let tabBar = app.tabBars["Tab Bar"]
    let tabExplore = tabBar.buttons["Explore"]
    let tabCookBook = tabBar.buttons["CookBook"]
    exploreButton.tap()
    XCTAssertTrue(tabExplore.isSelected)
    XCTAssertFalse(tabCookBook.isSelected)
  }

  func test_appInitialState_TabsExists_GoToNewRecipe() {
    startFromOnBoarding()
    let addRecipeButton = app.buttons["\(TextsConstants.emptyCookBookAddNewRecipes)"]
    let newRecipeScreen = app.navigationBars["Add New Recipe"]
    XCTAssertFalse(newRecipeScreen.exists)
    addRecipeButton.tap()
    XCTAssertTrue(newRecipeScreen.exists)
  }
  func test_appExploreTab() {
    startFromOnBoarding()
    let tabBar = app.tabBars["Tab Bar"]
    let tabExplore = tabBar.buttons["Explore"]
    tabExplore.tap()
    let exploretabNavigationBar = app.navigationBars["Explore"]
    let exploretabSearchBarImage = app.images["searchImage"]
    let exploretabSearchTextField = app.textFields["searchTextField"]
    let exploretabImage = app.images["magnifyingglass"]
    let exploretabText = app.staticTexts["What Are You Craving?"]
    XCTAssertTrue(exploretabNavigationBar.exists)
    XCTAssertTrue(exploretabSearchBarImage.exists)
    XCTAssertTrue(exploretabSearchTextField.exists)
    XCTAssertTrue(exploretabText.exists)
  }

  func test_ExploreRecipesView_searchEmptyText() {
    startFromOnBoarding()
    let tabBar = app.tabBars["Tab Bar"]
    let tabExplore = tabBar.buttons["Explore"]
    tabExplore.tap()
    let exploretabSearchTextField = app.textFields["searchTextField"]
    exploretabSearchTextField.tap()

    if app.keyboards.count == 1 {
      let returnButton = app.buttons["Search"]
      returnButton.tap()

      let alert = app.alerts.firstMatch
      if alert.exists {
        XCTAssertTrue(alert.exists)
        XCTAssertEqual(alert.label, "Please enter something to search")
        let alertButton = alert.buttons["OK"]
        alertButton.tap()
        XCTAssertFalse(alert.exists)
      }
    } else {
      print("Could not run test: test_ExploreRecipesView_searchEmptyText."
      + "Please Make sure to 'Toggle the keyboard` on the simulator")
    }
  }

  func test_ExploreRecipesView_searchTextProgressView() {
    startFromOnBoarding()
    let tabBar = app.tabBars["Tab Bar"]
    let tabExplore = tabBar.buttons["Explore"]
    tabExplore.tap()
    let exploretabSearchTextField = app.textFields["searchTextField"]
    exploretabSearchTextField.tap()
    if app.keyboards.count == 1 {
      app.keys["A"].tap()
      app.keys["p"].tap()
      app.keys["p"].tap()
      app.keys["l"].tap()
      app.keys["e"].tap()
      let returnButton = app.buttons["Search"]
      returnButton.tap()

      let progressView = app.activityIndicators.firstMatch
      let progressViewText = app.staticTexts["Looking for recipes ..."]
      XCTAssertTrue(progressViewText.exists)
      XCTAssertTrue(progressView.exists)
    } else {
      print("Could not run test: test_ExploreRecipesView_searchEmptyText."
      + "Please Make sure to 'Toggle the keyboard` on the simulator")
    }
  }

  func test_NewRecipe_AddNewSection() {
    startFromOnBoarding()

    var addRecipeButton = app.buttons["\(TextsConstants.emptyCookBookAddNewRecipes)"]
    if !addRecipeButton.exists {
      addRecipeButton = app.navigationBars["My Recipes"].buttons["New Recipe"].staticTexts["New Recipe"]
    }
    addRecipeButton.tap()
    let newRecipeNavigationBar = app.navigationBars["Add New Recipe"]
    let collectionViewsQuery = app.collectionViews
    let recipeNameTextField = app.textFields["recipeName"]
    let recipeDescriptionTextField = app.collectionViews.textViews["recipDescription"]
    let addInstructionButton = app.collectionViews.buttons["Add Ingredient"]
    let addIngredientButton = app.collectionViews.buttons["Add Instruction"]

    XCTAssertTrue(recipeNameTextField.exists)
    XCTAssertTrue(recipeDescriptionTextField.exists)
    XCTAssertTrue(addInstructionButton.exists)
    XCTAssertTrue(addIngredientButton.exists)

    addInstructionButton.tap()

    let ingredientSectionListNavigationBar =
    app.navigationBars["Ingredient List"].staticTexts["Section"]

    XCTAssert(ingredientSectionListNavigationBar.exists)
    ingredientSectionListNavigationBar.tap()
    let alert = app.alerts.firstMatch
    if alert.exists {
      XCTAssertTrue(alert.exists)
      XCTAssertEqual(alert.label, "Add Section")
      let alertButton = alert.buttons["OK"]
      let alertTextField = alert.textFields["Section Name"]
      alertTextField.typeText("Apple")
      alertButton.tap()
      XCTAssertFalse(alert.exists)
    }
  }
  func test_exploreRecipe_addRecipeToCookBook() {
    startFromOnBoarding()

    let tabBar = app.tabBars["Tab Bar"]
    let tabExplore = tabBar.buttons["Explore"]
    tabExplore.tap()
    let exploretabSearchTextField = app.textFields["searchTextField"]
    exploretabSearchTextField.tap()
    exploretabSearchTextField.typeText("Apple")

    let returnButton = app.buttons["Search"]
    returnButton.tap()

    _ = returnButton.waitForExistence(timeout: 2)

    let scrollViewsQuery = app.scrollViews
    let elementsQuery = scrollViewsQuery.otherElements
    let applePieFromScratch1Hour15MinutesButton = elementsQuery.buttons["Apple Pie From Scratch, 1 hour 15 minutes"]
    let loveButton = applePieFromScratch1Hour15MinutesButton.buttons["Love"]
    loveButton.tap()

    let tabCookBook = tabBar.buttons["CookBook"]
    tabCookBook.tap()
    XCTAssertTrue(applePieFromScratch1Hour15MinutesButton.exists)
    applePieFromScratch1Hour15MinutesButton.tap()

    let exploreRecipeDetailTabButton = app.navigationBars["My Recipes"].buttons["New Recipe"].staticTexts["New Recipe"]
  }
}
