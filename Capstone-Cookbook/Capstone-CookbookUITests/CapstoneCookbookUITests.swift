//
//  CapstoneCookbookUITests.swift
//  CapstoneCookbookUITests
//
//  Created by Samah Ktaifan on 02/07/2024.
//

import XCTest

final class CapstoneCookbookUITests: XCTestCase {
  let app = XCUIApplication()
  override func setUpWithError() throws {
    continueAfterFailure = false
    app.launch()
  }
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  func testExample() throws {
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }

  func test_ExploreRecipesView_shouldSearchEmptyText() {
    let searchTextField = app.textFields["searchTextField"]

    XCTAssertTrue(searchTextField.exists)

    searchTextField.tap()
    app.keys["A"].tap()
    app.keys["p"].tap()
    app.keys["p"].tap()
    app.keys["l"].tap()
    app.keys["e"].tap()
    let returnButton = app.buttons["Search"]
    returnButton.tap()

    // search Empty text: show an alert to enter something
    // search text: loading, found result, display it on screen
  }
}
