//
//  PetProjectTestsUI.swift
//  PetProjectTestsUI
//
//  Created by user on 04.12.2025.
//

import XCTest


final class Test: XCTestCase {
    
    @MainActor
    func testChnageTemperaturaUnit() throws {
        let app = XCUIApplication()
        app.activate()
        app/*@START_MENU_TOKEN@*/.buttons["4 Dec 2025 at 00:00, 6°C, 96%"]/*[[".buttons.containing(.staticText, identifier: \"4 Dec 2025 at 00:00\")",".otherElements.buttons[\"4 Dec 2025 at 00:00, 6°C, 96%\"]",".buttons[\"4 Dec 2025 at 00:00, 6°C, 96%\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        
        let element = app/*@START_MENU_TOKEN@*/.buttons["BackButton"]/*[[".navigationBars",".buttons[\"Back\"]",".buttons[\"BackButton\"]",".buttons"],[[[-1,2],[-1,1],[-1,3],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch
        element.tap()
        app/*@START_MENU_TOKEN@*/.buttons["gearshape"]/*[[".otherElements[\"gearshape\"].buttons",".otherElements.buttons[\"gearshape\"]",".buttons[\"gearshape\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Units, °C"]/*[[".buttons.containing(.staticText, identifier: \"°C\")",".otherElements.buttons[\"Units, °C\"]",".buttons[\"Units, °C\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        app/*@START_MENU_TOKEN@*/.buttons["°F"]/*[[".cells.buttons[\"°F\"]",".buttons[\"°F\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        app/*@START_MENU_TOKEN@*/.buttons["BackButton"]/*[[".navigationBars",".buttons",".buttons[\"Back\"]",".buttons[\"BackButton\"]"],[[[-1,3],[-1,2],[-1,0,1]],[[-1,3],[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        app/*@START_MENU_TOKEN@*/.buttons["4 Dec 2025 at 00:00, 43°F, 96%"]/*[[".buttons",".containing(.staticText, identifier: \"43°F\")",".containing(.staticText, identifier: \"4 Dec 2025 at 00:00\")",".otherElements.buttons[\"4 Dec 2025 at 00:00, 43°F, 96%\"]",".buttons[\"4 Dec 2025 at 00:00, 43°F, 96%\"]"],[[[-1,4],[-1,3],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        element.tap()
        
    }
    
}



//final class PetProjectTestsUI: XCTestCase {
//
//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//
//        // In UI tests it is usually best to stop immediately when a failure occurs.
//        continueAfterFailure = false
//
//        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//    @MainActor
//    func testExample() throws {
//        // UI tests must launch the application that they test.
//        let app = XCUIApplication()
//        app.launch()
//
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//
//    @MainActor
//    func testLaunchPerformance() throws {
//        // This measures how long it takes to launch your application.
//        measure(metrics: [XCTApplicationLaunchMetric()]) {
//            XCUIApplication().launch()
//        }
//    }
//}
