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
    continueAfterFailure = false
    //    app.launchArguments = ["enable-testing"]
    app.launch()
  }
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  func testExample() throws {
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }

  func test_ExploreRecipeView_initialState() {
    //    let searchTextField = app.textFields["searchTextField"]
    let searchTextField = app.textFields["Search A Recipe..."]
    let searchStateTitle = app.staticTexts["Enter something to search"]
    let searchstateviewImage = app.images["magnifyingglass"]
    let searchTextFieldPlaceHolder = searchTextField.placeholderValue
    XCTAssertTrue(searchTextField.exists)
    XCTAssertEqual(searchTextFieldPlaceHolder, "Search A Recipe...")
    XCTAssertTrue(searchStateTitle.exists)
    XCTAssertTrue(searchstateviewImage.exists)
  }

  func test_ExploreRecipesView_searchEmptyText() {
    let searchTextField = app.textFields["Search A Recipe..."]
    searchTextField.tap()
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


    //    app/*@START_MENU_TOKEN@*/.textFields["SearchAlert"]/*[[".textFields[\"Search A Recipe...\"]",".textFields[\"SearchAlert\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    //    app/*@START_MENU_TOKEN@*/.buttons["Search"]/*[[".keyboards",".buttons[\"search\"]",".buttons[\"Search\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
    //    app.alerts["Please enter something to search"].scrollViews.otherElements.buttons["OK"].tap()
    //
    ////    app.keys["A"].tap()
    ////    app.keys["p"].tap()
    ////    app.keys["p"].tap()
    ////    app.keys["l"].tap()
    ////    app.keys["e"].tap()
    //    let returnButton = app.buttons["Search"]
    //    returnButton.tap()
    //
    //
    //    let searchstateviewImage = app.images["SearchStateView"]
    //    searchstateviewImage.tap()
    //    app/*@START_MENU_TOKEN@*/.staticTexts["SearchStateView"]/*[[".staticTexts[\"Enter something to search\"]",".staticTexts[\"SearchStateView\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    // search Empty text: show an alert to enter something
    // search text: loading, found result, display it on screen
  }

  func test_ExploreRecipesView_searchTextProgressView() {
    let searchTextField = app.textFields["Search A Recipe..."]
    searchTextField.tap()
    app.keys["A"].tap()
    app.keys["p"].tap()
    app.keys["p"].tap()
    app.keys["l"].tap()
    app.keys["e"].tap()
    let returnButton = app.buttons["Search"]
    returnButton.tap()
    let progressView = app.activityIndicators.firstMatch
    let progressViewText = app.staticTexts["Searching..."]
    XCTAssertTrue(progressViewText.exists)
    XCTAssertTrue(progressView.exists)
  }

  func test_ExploreRecipesView_searchTextsShowResults() {
//    let searchTextField = app.textFields["Search A Recipe..."]
//    searchTextField.tap()
//    app.keys["A"].tap()
//    app.keys["p"].tap()
//    app.keys["p"].tap()
//    app.keys["l"].tap()
//    app.keys["e"].tap()
//    //    let returnButton = app.buttons["Search"]
//    //    returnButton.tap()
//    //    let gridExists = app.tables.firstMatch.waitForExistence(timeout: 3)
//    //    if gridExists {
//    //      print("YES")
//    //    }else {
//    //      print("NO")
//    //    }
//    let exists = app.scrollViews.firstMatch.waitForExistence(timeout: 5)
//    if exists {
//      print("YES")
//    } else {
//      print("NO")
//    }
    //    let scrollview = app.scrollViews.element(boundBy: 0)
    //    guard var lastCell = scrollview.images.allElementsBoundByIndex.last else { return }
    // Add in a count, so that the loop can escape if it's scrolled too many times
    //    let MAX_SCROLLS = 10
    //    var count = 0
    //    while lastCell.isHittable == false && count < MAX_SCROLLS {
    //      app.swipeUp()
    //      count += 1
    //      lastCell = scrollview.images.allElementsBoundByIndex.last!
    //    }
    //    XCTAssertTrue(lastCell.label == "50.square.fill")
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.


  }
}
