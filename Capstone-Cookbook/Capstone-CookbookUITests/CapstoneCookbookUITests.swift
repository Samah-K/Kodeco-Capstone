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
    // UI tests must launch the application that they test.
//    let app = XCUIApplication()
//    app.launch()
//
//    //    let app = XCUIApplication()
//    app.textFields["Search A Recipe..."].tap()
//
//    let elementsQuery2 = app.scrollViews.otherElements
//    let applePieFromScratchStaticText = elementsQuery2/*@START_MENU_TOKEN@*/.staticTexts["Apple Pie From Scratch"]/*[[".buttons[\"Apple Pie From Scratch\"].staticTexts[\"Apple Pie From Scratch\"]",".staticTexts[\"Apple Pie From Scratch\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//    applePieFromScratchStaticText.tap()
//
//    let instructionsStaticText = elementsQuery2/*@START_MENU_TOKEN@*/.staticTexts["Instructions"]/*[[".disclosureTriangles[\"Instructions\"].staticTexts[\"Instructions\"]",".staticTexts[\"Instructions\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//    instructionsStaticText.tap()
//
//    let elementsQuery = elementsQuery2.scrollViews.otherElements
//    elementsQuery.staticTexts["Step 2 - Add in cubed butter and break up into flour with a fork. Mixture will still have lumps about the size of small peas."]/*@START_MENU_TOKEN@*/.swipeRight()/*[[".swipeUp()",".swipeRight()"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//
//    let step10RollTheDoughAroundTheRollingPinAndUnrollOntoAPieDishMakingSureTheDoughReachesAllEdgesTrimExtraIfNecessaryStaticText = elementsQuery.staticTexts["Step 10 - Roll the dough around the rolling pin and unroll onto a pie dish making sure the dough reaches all edges. Trim extra if necessary."]
//    step10RollTheDoughAroundTheRollingPinAndUnrollOntoAPieDishMakingSureTheDoughReachesAllEdgesTrimExtraIfNecessaryStaticText.tap()
//    step10RollTheDoughAroundTheRollingPinAndUnrollOntoAPieDishMakingSureTheDoughReachesAllEdgesTrimExtraIfNecessaryStaticText.tap()
//    elementsQuery.staticTexts["Step 9 - On a floured surface, cut the pie dough in half and roll out both halves until round and about ⅛-inch (3 mm) thick."].swipeDown()
//
//    let ttgc7swiftui32navigationstackhostingNavigationBar = app.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"]
//    ttgc7swiftui32navigationstackhostingNavigationBar/*@START_MENU_TOKEN@*/.buttons["Love"]/*[[".otherElements[\"Love\"].buttons[\"Love\"]",".buttons[\"Love\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//    ttgc7swiftui32navigationstackhostingNavigationBar.buttons["Explore"].tap()
//    elementsQuery2.buttons["Apple Pie From Scratch"].buttons["Love"].tap()
//
//    let tabBar = app.tabBars["Tab Bar"]
//    let cookbookButton = tabBar.buttons["CookBook"]
//    cookbookButton.tap()
//    tabBar.buttons["Explore"].tap()
//    cookbookButton.tap()
//    applePieFromScratchStaticText.tap()
//    instructionsStaticText.tap()
//    instructionsStaticText.tap()

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

    //search Empty text: show an alert to enter something
    //search text: loading, found result, display it on screen

  }

}
